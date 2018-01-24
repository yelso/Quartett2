//
//  StoreScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 10.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class StoreScene: SKScene, DownloadDelegate {

    var downloads = [Int: DownloadUtil]()
    var cells = [Int: ActionNode]()
    var progress = [Int: SKSpriteNode]()
    var origin = "MainMenuScene"

    override func didMove(to view: SKView) {
        let backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        backButton.action = {
            if let scene = SKScene(fileNamed: self.origin) {
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
        self.addChild(backButton)
        
        let title = SKLabelNode(text: "Store")
        title.fontName = Font.buttonFont
        title.position = CGPoint(x: -160, y: 260)
        title.horizontalAlignmentMode = .left
        self.addChild(title)
        
        let request = HTTPRequestService.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/")
        
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let decks = try JSONDecoder().decode([Deck].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    let files = FileUtils.getFilesWith(suffix: ".json")
                    for index in 0..<decks.count {
                        if !files.contains(decks[index].name!.lowercased() + ".json") {
                            let cell = ActionNode(color: Color.darkOrange, size: CGSize(width: 320, height: 50))
                            cell.position = CGPoint(x: 0, y: 180 - (index * 60))
                            cell.action = {
                                self.startDownload(decks[index])
                            }
                            let labelNode = SKLabelNode(text: decks[index].name)
                            labelNode.position = CGPoint(x: 0, y: 0)
                            labelNode.horizontalAlignmentMode = .center
                            labelNode.fontName = Font.buttonFont
                            labelNode.fontColor = .white
                            labelNode.fontSize = title.fontSize-4.0
                            labelNode.verticalAlignmentMode = .center
                            
                            let progressNode = SKSpriteNode(color: .white, size: CGSize(width: 0, height: 0))
                            progressNode.anchorPoint = CGPoint(x: 0, y: 0)
                            progressNode.position = CGPoint(x: -160, y: -25)
                            
                            cell.addChild(labelNode)
                            cell.addChild(progressNode)
                            self.progress[decks[index].id!] = progressNode
                            self.cells[decks[index].id!] = cell
                            self.addChild(cell)
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
   
    func didStartdownload(deckId: Int) {
        
    }
    
    func didFinishDownload(deckId: Int) {
        DispatchQueue.main.async {
            if let prog = self.progress[deckId] {
                let action = SKAction.sequence( [SKAction.resize(toHeight: 0, duration: 0.6), SKAction.run({
                    self.downloads.removeValue(forKey: deckId)
                    self.cells[deckId]?.removeFromParent()
                    self.cells.removeValue(forKey: deckId)
                    self.updateCellPositions()
                })])
                prog.run(action)
            }
        }
    }
    
    func didCancelDownload(deckId: Int) {
        DispatchQueue.main.async {
            if let prog = self.progress[deckId] {
                let action = SKAction.sequence([SKAction.resize(toWidth: 0, duration: 0.8), SKAction.run({
                    self.downloads.removeValue(forKey: deckId)
                })])
                prog.run(action)
            }
        }
    }
    
    func startDownload(_ deck: Deck) {
        guard downloads[deck.id!] == nil else { return }
        downloads[deck.id!] = DownloadUtil(delegate: self, deck: deck)
    }
    
    func updateCellPositions() {
        var count = 0
        for cell in cells.values {
            cell.position = CGPoint(x: 0, y: 180 - (count * 60))
            count += 1
        }
    }
    
    func updateProgess(deckId: Int, progress: Float) {
        DispatchQueue.main.async {
            if let prog = self.progress[deckId] {
                prog.size = CGSize(width: Int(320 * progress), height: 5)
            }
        }
    }
}
