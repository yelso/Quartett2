//
//  CardSetOverviewScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class CardSetOverviewScene: SKScene {
   
    var card1: ActionNode!
    var card2: ActionNode!
    
    override func didMove(to view: SKView) {
        // TODO: add cards dynamically and set values
        card1 = self.childNode(withName: "card1") as! ActionNode
        card1.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                // Set the scale mode to scale to fit the window
                scene.imgName = "tuning1"
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
            
        }
        
        card2 = self.childNode(withName: "card2") as! ActionNode
        card2.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                // Set the scale mode to scale to fit the window
                scene.imgName = "tuning2"
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
            
        }
    }
}
