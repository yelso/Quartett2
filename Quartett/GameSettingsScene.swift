//
//  GameSettingsScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 28.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class GameSettingsScene: SKScene {
    
    var rounds1Button: GroupActionNode!
    var rounds2Button: GroupActionNode!
    var rounds3Button: GroupActionNode!
    var startGameButton: ActionNode!
    var settings: GameSettings = GameSettings()
    
    override func didMove(to view: SKView) {
        
        // Group Round Buttons
        rounds1Button = self.childNode(withName: "rounds1Button") as! GroupActionNode
        rounds2Button = self.childNode(withName: "rounds2Button") as! GroupActionNode
        rounds3Button = self.childNode(withName: "rounds3Button") as! GroupActionNode
        
        rounds1Button.setUpGroup([rounds1Button, rounds2Button, rounds3Button])
        
        rounds1Button.onTouch = {
            // TODO button 1-3
        }
        rounds1Button.onTouchEnd = {
            // TODO button 1-3
        }
        
        rounds1Button.onTouchGroup = {
            // TODO: what happens to other group members after one member was tapped/selected?
        }
        
        rounds1Button.onTouchEndGroup = {
            // TODO: what happens to other group members after tap ended on one member?
        }
        
        rounds1Button.action = {
            self.settings.maxRounds = 10
        }
        
        settings.difficulty = 1
        settings.cardSetName = "tuning"
        // Group Difficulty Buttons
        // TODO
        
        startGameButton = self.childNode(withName: "startGameButton") as! ActionNode
        // TODO: onTouch(End) func
        startGameButton.action = {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.game = Game(withSettings: self.settings)
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
    }
    
}
