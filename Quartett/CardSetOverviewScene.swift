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
        
        cardSetButton1 = ActionNode(color: Color.green1, size: CGSize(width: 100, height: 50))
        cardSetButton2 = ActionNode(color: Color.green2, size: CGSize(width: 100, height: 50))
        
        cardSetButton1.position = CGPoint(x: -110, y: 220)
        cardSetButton2.position = CGPoint(x: 0, y: 220)
        
        let cardLabel1 = SKLabelNode(text: CardSets.tuning.rawValue)
        let cardLabel2 = SKLabelNode(text: CardSets.bikes.rawValue)
        cardLabel1.verticalAlignmentMode = .center
        cardLabel2.verticalAlignmentMode = .center
        cardLabel1.fontName = Font.buttonFont
        cardLabel2.fontName = Font.buttonFont
        cardSetButton1.addChild(cardLabel1)
        cardSetButton2.addChild(cardLabel2)
        
        let cardSetLabel = SKLabelNode(text: "Kartenset")
        cardSetLabel.position = CGPoint(x: -160, y: 260)
        cardSetLabel.horizontalAlignmentMode = .left
        cardSetLabel.fontName = Font.buttonFont
        
        //Back Button
        backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        
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
                scene.cardSet = CardSets.decode(resource: CardSets.tuning)
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        cardSetButton2.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                // Set the scale mode to scale to fit the window
                scene.cardSet = CardSets.decode(resource: CardSets.bikes)
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
    }
}
