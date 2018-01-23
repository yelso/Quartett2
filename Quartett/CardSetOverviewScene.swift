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
   
    var buttonPlus: ActionNode!
    var backButton: ActionNode!
    
    var buttonArrary = [GroupActionNode]()
    
    override func didMove(to view: SKView) {
        
        let cardSetNamesArray = FileUtils.filesWithExtension()
        let multi  = (1-0.2)/CGFloat(cardSetNamesArray.count)
        for index in 0..<cardSetNamesArray.count {
            let green = UIColor(red: 0.01, green: 0.8-(CGFloat(index) * multi) + 0.2, blue: 0.05, alpha: 1.0)
            let button = GroupActionNode(color: green, size: CGSize(width: 100, height: 50))
            button.position = CGPoint(x: -110 + index%3 * 110, y: 220 - Int(index/3) * 55)
       
            let cardLabel = SKLabelNode(text: "\(cardSetNamesArray[index].dropLast(5))")
            cardLabel.verticalAlignmentMode = .center
            cardLabel.fontName = Font.buttonFont
            button.addChild(cardLabel)
            
            buttonArrary.append(button)
            self.addChild(button)
            
            button.action = {
                if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                    // Set the scale mode to scale to fit the window
                    scene.cardSet = CardSets.decode(resource: "\(cardSetNamesArray[index].dropLast(5))")
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.push(with: .left, duration: 0.5)
                    // Present the scene
                    view.presentScene(scene, transition: transition)
                }
            }
        }
        
        buttonPlus = ActionNode(color: UIColor(red: 0.01, green: 0.8-(CGFloat(buttonArrary.count) * multi) + 0.2, blue: 0.05, alpha: 1.0), size: CGSize(width: 100, height: 50))
        buttonPlus.position = CGPoint(x: -110 + (buttonArrary.count)%3 * 110, y: 220 - Int((buttonArrary.count)/3) * 55)
        let cardLabel = SKLabelNode(text: "+")
        cardLabel.verticalAlignmentMode = .center
        cardLabel.fontName = Font.buttonFont
        buttonPlus.addChild(cardLabel)
        
        self.addChild(buttonPlus)
        
        
        /*cardSetButton1 = ActionNode(color: Color.green1, size: CGSize(width: 100, height: 50))
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
        */
        
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
        //self.addChild(cardSetButton1)
        //self.addChild(cardSetButton2)
        self.addChild(cardSetLabel)
        
        buttonPlus.action = {
            if let scene = SKScene(fileNamed: "StoreScene") as? StoreScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                scene.origin = "CardSetOverviewScene"
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
 /*
        cardSetButton1.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                // Set the scale mode to scale to fit the window
                scene.cardSet = CardSets.decode(resource: "tuning")
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        cardSetButton2.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                // Set the scale mode to scale to fit the window
                scene.cardSet = CardSets.decode(resource: "bikes")
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        } */
    }
}
