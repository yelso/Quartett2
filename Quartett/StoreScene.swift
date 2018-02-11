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
    var createCardCell : ActionNode!
    var origin = "MainMenuScene"

    override func didMove(to view: SKView) {
        let backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        backButton.action = {
            if let scene = SKScene(fileNamed: self.origin) {
                self.removeAllActions()
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
        
        let loading = SKLabelNode(text: "Laden...")
        loading.fontName = Font.buttonFont
        loading.position = CGPoint(x: -loading.frame.width/2, y: 0)
        loading.horizontalAlignmentMode = .left
        let action = SKAction.repeatForever(SKAction.sequence([SKAction.run({
            loading.text = "Laden.."
        }), SKAction.wait(forDuration: 0.5),
            SKAction.run({
            loading.text = "Laden..."
        }), SKAction.wait(forDuration: 0.5)
        ]))
        loading.run(action)
        self.addChild(loading)
        
        let action2 = SKAction.afterDelay(0.6, runBlock: {
            
        
        let request = HTTPRequestService.setUpGETRequestFor(url: "http://quartett.af-mba.dbis.info/decks/")
        
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let decks = try JSONDecoder().decode([Deck].self, from: data)
                loading.removeAllActions()
                loading.removeFromParent()
                //Get back to the main queue
                DispatchQueue.main.async {
                    let files = FileUtils.getFilesWith(suffix: ".json")
                    var count = 0
                    //let multi = CGFloat(1.0-0.6)/CGFloat(decks.count)
                    for index in 0..<decks.count {
                        if files.contains(decks[index].name!.lowercased() + ".json") {
                            count += 1
                            let cell = ActionNode(color: Color.darkOrange, size: CGSize(width: 320, height: 50))
                            //cell.color = UIColor(red: 1.0, green: 0.2 + CGFloat(index)*multi, blue: 0, alpha: 1.0)
                            cell.position = CGPoint(x: 0, y: 220 - ((count-1) * 60))
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
                            print(cell.position)
                        }
                    }
                    if (count == 0) {
                        let line1 = SKLabelNode(text: "Du hast bereits alle")
                        let line2 = SKLabelNode(text: "verfügbaren Decks heruntergeladen")
                        
                        line1.position = CGPoint(x: 0, y: 205 - line1.frame.height/2)
                        line1.horizontalAlignmentMode = .center
                        line1.fontSize = 21
                        line1.fontName = Font.buttonFont
                        
                        line2.position = CGPoint(x: 0, y: 205 - line1.frame.height * 2)
                        line2.horizontalAlignmentMode = .center
                        line2.fontSize = 21
                        line2.fontName = Font.buttonFont
                        
                        self.addChild(line1)
                        self.addChild(line2)
                        self.createCardCell = self.createAddCardSetButton(view, posY: 120, count: 0, size: title.fontSize - 4)
                    } else {
                        let multi = CGFloat(1.0-0.6)/CGFloat(self.cells.count)
                        var index = 0
                        for cell in self.cells.values {
                            cell.color = UIColor(red: 1.0, green: 0.2 + CGFloat(index)*multi, blue: 0, alpha: 1.0)
                            index += 1
                        }
                        self.createCardCell = self.createAddCardSetButton(view, posY: 220 - (count * 60), count: count, size: title.fontSize - 4)
                    }
                    
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
        })
        
        self.run(action2)
    }
    
    func createAddCardSetButton(_ view: SKView, posY: Int, count: Int, size: CGFloat) -> ActionNode {
        let multi = count > 0 ? CGFloat(1.0-0.6)/CGFloat(count) : 0
        let cell = ActionNode(color: UIColor(red: 1.0, green: 0.2 + CGFloat(count)*multi, blue: 0, alpha: 1.0), size: CGSize(width: 320, height: 50))
        cell.position = CGPoint(x: 0, y: posY)
        cell.action = {
            if let scene = SKScene(fileNamed: "CreateCardSetScene") as? CreateCardSetScene {
                self.removeAllActions()
                 if UIScreen.main.bounds.height == 812 {
                    scene.scaleMode = .aspectFill
                 } else {
                scene.scaleMode = .aspectFill
                }
                scene.origin = self.origin
                //scene.store = self
                let transition = SKTransition.push(with: .left, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
        let labelNode = SKLabelNode(text: "Kartenset erstellen")
        labelNode.position = CGPoint(x: 0, y: 0)
        labelNode.horizontalAlignmentMode = .center
        labelNode.fontName = Font.buttonFont
        labelNode.fontColor = .white
        labelNode.fontSize = size
        labelNode.verticalAlignmentMode = .center
        cell.addChild(labelNode)
        self.addChild(cell)
        return cell
    }
   
    func didStartDownload(deckId: Int) {
        
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
        var count: Double = 0
        for cell in cells.values {
            cell.removeAllActions()
            //cell.position = CGPoint(x: 0, y: 180 - (count * 60))
            cell.run(SKAction.moveTo(y: CGFloat(220 - (count * 60)), duration: 0.5))
            count += 1
        }
        if count == 0 {
            createCardCell.run(SKAction.moveTo(y: 120, duration: 0.5))
        } else {
            createCardCell.run(SKAction.moveTo(y: CGFloat(220 - (count * 60)), duration: 0.5))
        }
    }
    
    func updateDownloadProgess(deckId: Int, progress: Float) {
        DispatchQueue.main.async {
            if let prog = self.progress[deckId] {
                prog.size = CGSize(width: Int(320 * progress), height: 5)
            }
        }
    }
}

extension SKAction {
    /**
     * Performs an action after the specified delay.
     */
    class func afterDelay(_ delay: TimeInterval, performAction action: SKAction) -> SKAction {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }
    /**
     * Performs a block after the specified delay.
     */
    class func afterDelay(_ delay: TimeInterval, runBlock block: @escaping () -> Void) -> SKAction {
        return SKAction.afterDelay(delay, performAction: SKAction.run(block))
    }
}
