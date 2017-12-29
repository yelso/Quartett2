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
    
    var startButton: ActionNode!
    var cardsOverviewButton: ActionNode!
    var rulesButton: ActionNode!
    override func didMove(to view: SKView) {
        cardsOverviewButton = self.childNode(withName: "cardsOverviewButton") as! ActionNode
        cardsOverviewButton.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
                
            }
        }
        
        startButton = self.childNode(withName: "startButton") as! ActionNode
        startButton.action = {
            if let scene = SKScene(fileNamed: "GameSettingsScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        
        }
        startButton.onTouch = {self.startButton?.run(SKAction.scale(to: 0.95, duration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0))
        }
        
        startButton.onTouchEnd = {
            self.startButton?.run(SKAction.scale(to: 1.0, duration: 0.03))
        }
        
        rulesButton = self.childNode(withName: "rulesButton") as! ActionNode
        
    }
  
}
