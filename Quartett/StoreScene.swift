//
//  StoreScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 10.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class StoreScene: SKScene, DownloadDelegate {

    var downloads = [Int: DownloadUtil]()
    var cells = [Int: ActionNode]()
    var cellPositions = [Int: Int]() // TODO: change structure of 'cells' so this dictionary becomes unnecessary
    //var progress = [Int: SKSpriteNode]()
    var createCardCell : ActionNode!
    static var origin = "MainMenuScene"
    var countInvis = 0
    var errorAlert: UIAlertController?
    var loadingAlert: UIAlertController?
    var progressAlert: UIAlertController?
    var loadingIndicator: UIActivityIndicatorView?
    var progressView: UIProgressView?
    var session: URLSessionDataTask?

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let deltaY = location.y - previousLocation.y
            camera!.position.y -= deltaY
        }
    } 
    
    override func didMove(to view: SKView) {
        let cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        self.camera = cameraNode
        camera!.constraints = [SKConstraint.positionY(SKRange(lowerLimit: 0))]
        let backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        backButton.action = {
            if let scene = SKScene(fileNamed: StoreScene.origin) {
                if self.session != nil {
                    self.session?.cancel()
                }
                self.removeAllActions()
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
        camera!.addChild(backButton)
        
        let title = SKLabelNode(text: "Store")
        title.fontName = Font.buttonFont
        title.position = CGPoint(x: -160, y: 260)
        title.horizontalAlignmentMode = .left
        camera!.addChild(title)
        
        let topBox = SKSpriteNode(color: Color.background, size: CGSize(width: self.size.width, height: 300))
        topBox.anchorPoint = CGPoint(x: 0.5, y: 0)
        topBox.position = CGPoint(x: 0, y: 250)
        topBox.zPosition = -1
        let bottomBox = SKSpriteNode(color: Color.background, size: CGSize(width: self.size.width, height: 300))
        bottomBox.anchorPoint = CGPoint(x: 0.5, y: 1)
        bottomBox.position = CGPoint(x: 0, y: backButton.position.y)
        bottomBox.zPosition = -1
        
        camera!.addChild(topBox)
        camera!.addChild(bottomBox)
        
        let loading = SKLabelNode(text: "Laden...")
        loading.fontName = Font.buttonFont
        loading.position = CGPoint(x: -loading.frame.width/2, y: 0)
        loading.horizontalAlignmentMode = .left
        let action = SKAction.repeatForever(SKAction.sequence([SKAction.run({
            loading.text = "Laden.."
        }), SKAction.wait(forDuration: 0.3),
            SKAction.run({
            loading.text = "Laden..."
        }), SKAction.wait(forDuration: 0.3)
        ]))
        loading.run(action)
        self.addChild(loading)
        
        let action2 = SKAction.afterDelay(0.6, runBlock: {
            
        let request = HTTPRequestService.setUpGETRequestFor(url: "http://quartett.af-mba.dbis.info/decks/")
        
        self.session = URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print("error: \(error!.localizedDescription)")
            }
            guard let data = data else {
                loading.removeAllActions()
                loading.text = "Verbindung fehlgeschlagen."
                loading.horizontalAlignmentMode = .center
                loading.position = CGPoint(x: 0, y: 0)
                return
                
            }
            do {
                let decks = try JSONDecoder().decode([Deck].self, from: data)
                loading.removeAllActions()
                loading.removeFromParent()
                //Get back to the main queue
                DispatchQueue.main.async {
                    let files = FileUtils.getFilesWith(suffix: ".json")
                    var count = 0
                    for index in 0..<decks.count {
                        if !files.contains(decks[index].name!.lowercased() + ".json") {
                            count += 1
                            let cell = ActionNode(color: Color.darkOrange, size: CGSize(width: 320, height: 50))
                            cell.position = CGPoint(x: 0, y: 215 - ((count-1) * 60))
                            cell.isStatic = false
                            cell.action = {
                                self.askDownload(decks[index])
                            }
                            if cell.position.y < (self.size.height/2 * 0.8 * -1) {
                                self.countInvis += 1
                            }
                            let labelNode = SKLabelNode(text: decks[index].name)
                            labelNode.position = CGPoint(x: 0, y: 0)
                            labelNode.horizontalAlignmentMode = .center
                            labelNode.fontName = Font.buttonFont
                            labelNode.fontColor = .white
                            labelNode.fontSize = title.fontSize-4.0
                            labelNode.verticalAlignmentMode = .center
                            
                            cell.zPosition = -2
                            cell.addChild(labelNode)
                            self.cells[decks[index].id!] = cell
                            self.cellPositions[count-1] = decks[index].id!
                            self.addChild(cell)
                        }
                    }
                    if (count == 0) {
                        let line1 = SKLabelNode(text: "Du hast bereits alle")
                        let line2 = SKLabelNode(text: "verfügbaren Decks heruntergeladen")
                        
                        line1.position = CGPoint(x: 0, y: 205 - line1.frame.height/2)
                        line1.horizontalAlignmentMode = .center
                        line1.fontSize = 21
                        line1.fontName = Font.buttonFont
                        line1.zPosition = -2
                        
                        line2.position = CGPoint(x: 0, y: 205 - line1.frame.height * 2)
                        line2.horizontalAlignmentMode = .center
                        line2.fontSize = 21
                        line2.fontName = Font.buttonFont
                        line2.zPosition = -2
                        
                        self.addChild(line1)
                        self.addChild(line2)
                        self.createCardCell = self.createAddCardSetButton(view, posY: 120, count: 0, size: title.fontSize - 4)
                        self.camera!.constraints = [SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: 0))]
                    } else {
                        let multi = CGFloat(1.0-0.6)/CGFloat(self.cells.count)
                        for index in 0..<self.cellPositions.count {
                            let deckId = self.cellPositions[index]!
                            self.cells[deckId]!.color = UIColor(red: 1.0, green: 0.2 + CGFloat(index)*multi, blue: 0, alpha: 1.0)
                        }
                        self.createCardCell = self.createAddCardSetButton(view, posY: 215 - (count * 60), count: count, size: title.fontSize - 4)
                        if self.createCardCell.position.y < (self.size.height/2 * 0.8 * -1) {
                            self.countInvis += 1
                        }
                        self.camera!.constraints = [SKConstraint.positionY(SKRange(lowerLimit: CGFloat(-1 * (self.countInvis * 60)), upperLimit: 0))]
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }
            self.session?.resume()
        })
        
        self.run(action2)
    }
    
    func askDownload(_ deck: Deck) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "\(deck.name!) herunterladen", message: "Möchtest du das Kartenset \"\(deck.name!)\" herunterladen?", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Herunterladen", style: .default, handler: { (_) in
                self.showLoadingIndicator(deck)
            })
            let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLoadingIndicator(_ deck: Deck) {
        DispatchQueue.main.async {
            self.loadingAlert = UIAlertController(title: nil, message: "Überprüfen..", preferredStyle: .alert)
            
            self.loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            self.loadingIndicator!.hidesWhenStopped = true
            self.loadingIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.loadingIndicator!.startAnimating();
            
            self.loadingAlert?.view.addSubview(self.loadingIndicator!)
            self.view?.window?.rootViewController?.present(self.loadingAlert!, animated: true, completion: nil)
            self.startDownload(deck)
        }
    }
    
    func createAddCardSetButton(_ view: SKView, posY: Int, count: Int, size: CGFloat) -> ActionNode {
        let multi = count > 0 ? CGFloat(1.0-0.6)/CGFloat(count) : 0
        let cell = ActionNode(color: UIColor(red: 1.0, green: 0.2 + CGFloat(count)*multi, blue: 0, alpha: 1.0), size: CGSize(width: 320, height: 50))
        cell.position = CGPoint(x: 0, y: posY)
        cell.isStatic = false
        cell.action = {
            if let scene = SKScene(fileNamed: "CreateCardSetScene") as? CreateCardSetScene {
                self.removeAllActions()
                 if UIScreen.main.bounds.height == 812 {
                    scene.scaleMode = .aspectFill
                 } else {
                scene.scaleMode = .aspectFill
                }
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
        cell.zPosition = -2
        self.addChild(cell)
        return cell
    }
   
    func didStartDownload(deckId: Int, name: String) {
        DispatchQueue.main.async {
            self.loadingAlert?.dismiss(animated: true, completion: {
                self.loadingAlert = nil
                self.loadingIndicator = nil
                if self.progressAlert == nil {
                    self.progressAlert = UIAlertController(title: "\"\(name)\" herunterladen..", message: "Bitte schließe die App während dieser Aktion nicht.\n\n\n", preferredStyle: .alert)
                    
                    self.progressView = UIProgressView(frame: CGRect(x: 15, y: 100, width: 240, height: 5))
                    
                    self.progressAlert?.view.addSubview(self.progressView!)
                    self.view?.window?.rootViewController?.present(self.progressAlert!, animated: true, completion: nil)
                }
            })
        }
    }
    
    func didFinishDownload(deckId: Int, name: String) {
        DispatchQueue.main.async {
            self.progressAlert?.dismiss(animated: true, completion: {
                self.progressAlert = nil
                self.progressView = nil
                let finishAlert = UIAlertController(title: "Abgeschlossen", message: "\"\(name)\" wurde erfolgreich heruntergeladen.", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    if let cell = self.cells[deckId] {
                       // let action = SKAction.sequence( [SKAction.resize(toHeight: 0, duration: 0.6), SKAction.run({
                        cell.removeFromParent()
                        self.downloads.removeValue(forKey: deckId)
                        self.cells.removeValue(forKey: deckId)
                        self.updateCellPositions()
                       // })])
                       // prog.run(action)
                    }
                })
                finishAlert.addAction(dismissAction)
                self.view?.window?.rootViewController?.present(finishAlert, animated: true, completion: nil)
            })
        }
    }
    
    func didCancelDownload(deckId: Int, name: String, _ error: String?) {
        DispatchQueue.main.async {
            if let cell = self.cells[deckId] {
                // let action = SKAction.sequence( [SKAction.resize(toHeight: 0, duration: 0.6), SKAction.run({
                cell.removeFromParent()
                self.downloads.removeValue(forKey: deckId)
                self.cells.removeValue(forKey: deckId)
                self.updateCellPositions()
                // })])
                // prog.run(action)
            }
            if self.loadingAlert != nil {
                self.loadingAlert?.dismiss(animated: true, completion: {
                    self.loadingAlert = nil
                    if self.progressAlert != nil {
                        self.progressAlert?.dismiss(animated: true, completion: {
                            self.progressAlert = nil
                            self.progressView = nil
                            self.showError(error)
                        })
                    } else {
                        self.showError(error)
                    }
                })
                
            } else if self.progressAlert != nil {
                self.progressAlert?.dismiss(animated: true, completion: {
                    self.progressAlert = nil
                    self.progressView = nil
                    self.showError(error)
                })
            } else {
                self.showError(error)
            }
        }
    }
    
    func showError(_ error: String?) {
        DispatchQueue.main.async {
            if self.errorAlert == nil {
                self.errorAlert = UIAlertController(title: "Error", message: error == nil ? "Es ist ein Fehler aufgetreten. Bitte versuche es später erneut." : error, preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.errorAlert = nil
                }
                self.errorAlert!.addAction(dismissAction)
                self.view?.window?.rootViewController?.present(self.errorAlert!, animated: true, completion: nil)
            }
        }
    }
    
    func startDownload(_ deck: Deck) {
        guard downloads[deck.id!] == nil else {
            if loadingAlert != nil {
                loadingAlert?.dismiss(animated: true, completion: {
                    self.loadingAlert = nil
                    self.loadingIndicator = nil
                    let alert = UIAlertController(title: "Error", message: "\"\(deck.name!)\" wird bereits heruntergeladen.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
            return
        }
        downloads[deck.id!] = DownloadUtil(delegate: self, deck: deck)
    }
    
    func updateCellPositions() {
        var count: Double = 0
        countInvis = 0
        let multi = CGFloat(1.0-0.6)/CGFloat(self.cells.count)
        for cell in cells.values {
            cell.removeAllActions()
            //cell.position = CGPoint(x: 0, y: 180 - (count * 60))
            cell.run(SKAction.group([SKAction.moveTo(y: CGFloat(215 - (count * 60)), duration: 0.5), SKAction.colorize(with: UIColor(red: 1.0, green: 0.2 + CGFloat(count)*multi, blue: 0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.5)]))
            //cell.run(SKAction.moveTo(y: CGFloat(215 - (count * 60)), duration: 0.5))
            if cell.position.y < (self.size.height/2 * 0.8 * -1) {
                countInvis += 1
            }
            count += 1
        }
        if count == 0 {
            let line1 = SKLabelNode(text: "Du hast bereits alle")
            let line2 = SKLabelNode(text: "verfügbaren Decks heruntergeladen")
            
            line1.position = CGPoint(x: 0, y: 205 - line1.frame.height/2)
            line1.horizontalAlignmentMode = .center
            line1.fontSize = 21
            line1.fontName = Font.buttonFont
            line1.zPosition = -2
            line1.alpha = 0
            line2.position = CGPoint(x: 0, y: 205 - line1.frame.height * 2)
            line2.horizontalAlignmentMode = .center
            line2.fontSize = 21
            line2.fontName = Font.buttonFont
            line2.zPosition = -2
            line2.alpha = 0
            
            self.addChild(line1)
            self.addChild(line2)
            line1.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5))
            line2.run(SKAction.fadeAlpha(to: 1.0, duration: 0.5))
            createCardCell.run(SKAction.group([SKAction.colorize(with: UIColor(red: 1.0, green: 0.2, blue: 0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.5), SKAction.moveTo(y: 120, duration: 0.5)]))
            self.camera!.constraints = [SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: 215))]
        } else {
            createCardCell.run(SKAction.moveTo(y: CGFloat(215 - (count * 60)), duration: 0.5))
            if createCardCell.position.y < (self.size.height/2 * 0.80 * -1) {
                countInvis += 1
            }
            self.camera!.constraints = [SKConstraint.positionY(SKRange(lowerLimit: CGFloat(-1 * (countInvis * 60)), upperLimit: 0))]
        }
    }
    
    func updateDownloadProgress(deckId: Int, progress: Float) {
        DispatchQueue.main.async {
            self.progressView?.progress = progress
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
