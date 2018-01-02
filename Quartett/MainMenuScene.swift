//
//  MainMenuScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    let queue = DispatchQueue.global()
    var startButton: ActionNode!
    var cardsButton: ActionNode!
    var rulesButton: ActionNode!
    
    override func didMove(to view: SKView) {
        let backgroundAnim = SKSpriteNode(texture: SKTexture(image: UIImage(named: "shine_1")!))
        backgroundAnim.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundAnim.position = CGPoint(x: 0, y: 0)
        queue.async {
            backgroundAnim.run(SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 12)))
        }
        backgroundAnim.zPosition = -1
        self.addChild(backgroundAnim)
        
        let logo = SKSpriteNode(texture: SKTexture(image: UIImage(named:"logo_farbe")!))
        logo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logo.position = CGPoint(x: 0, y: 150)
        self.addChild(logo)
        
        startButton = self.childNode(withName: "startButton") as! ActionNode
        startButton.action =  {
            if let scene = SKScene(fileNamed: "GameSettingsScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
            
        }
        cardsButton = self.childNode(withName: "cardsButton") as! ActionNode
        cardsButton.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
                
            }
        }

        rulesButton = self.childNode(withName: "rulesButton") as! ActionNode
        
        rulesButton.action = {
            print("rules button tapped")
        }
        
    }
}
