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
   
    var cardSetButton1: ActionNode!
    var cardSetButton2: ActionNode!
    var backButton: ActionNode!
    
    override func didMove(to view: SKView) {
        
        cardSetButton1 = ActionNode(color: Color.green1, size: CGSize(width: 110, height: 50))
        cardSetButton2 = ActionNode(color: Color.green2, size: CGSize(width: 110, height: 50))
        
        cardSetButton1.position = CGPoint(x: -125, y: 220)
        cardSetButton2.position = CGPoint(x: -10, y: 220)
        
        let cardLabel1 = SKLabelNode(text: "Bikes")
        let cardLabel2 = SKLabelNode(text: "Tuning")
        cardLabel1.verticalAlignmentMode = .center
        cardLabel2.verticalAlignmentMode = .center
        cardSetButton1.addChild(cardLabel1)
        cardSetButton2.addChild(cardLabel2)
        
        let cardSetLabel = SKLabelNode(text: "Kartenset")
        cardSetLabel.position = CGPoint(x: -180, y: 260)
        cardSetLabel.horizontalAlignmentMode = .left
        
        backButton = ActionNode(color: Color.background, size: CGSize(width: 150, height: 50))
        
        //Back Button
        let endLabel = SKLabelNode(text: "< Zurück")
        backButton.position = CGPoint(x: -130, y: -320)
        endLabel.fontSize = 25
        endLabel.verticalAlignmentMode = .center
        backButton.addChild(endLabel)
       
        
        backButton.action = {
            if let scene = SKScene(fileNamed: "MainMenuScene") as? MainMenuScene {
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
        
        self.addChild(backButton)
        self.addChild(cardSetButton1)
        self.addChild(cardSetButton2)
        self.addChild(cardSetLabel)
 
        cardSetButton1.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                // Set the scale mode to scale to fit the window
                scene.imgName = "tuning1"
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
            
        }
        cardSetButton2.action = {
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
