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
        
        let cardSetNamesArray = FileUtils.getFilesWith(suffix: ".json")
        for cr in cardSetNamesArray {
            print(cr)
        }
        let multi  = (0.65-0.2)/CGFloat(cardSetNamesArray.count)
        for index in 0..<cardSetNamesArray.count {
            let green = UIColor(red: 0.01, green: 0.65-(CGFloat(index) * multi) + 0.2, blue: 0.05, alpha: 1.0)
            let button = GroupActionNode(color: green, size: CGSize(width: 158, height: 50))
            button.position = CGPoint(x: -84 + index%2 * 163, y: 220 - Int(index/2) * 55)
       
            let cardLabel = SKLabelNode(text: "\(cardSetNamesArray[index].dropLast(5))")
            cardLabel.verticalAlignmentMode = .center
            cardLabel.fontName = Font.buttonFont
            button.addChild(cardLabel)
            
            buttonArrary.append(button)
            self.addChild(button)
            
            button.action = {
                if let scene = SKScene(fileNamed: "CardSetOverviewDetailScene") as? CardSetOverviewDetailScene {
                    // Set the scale mode to scale to fit the window
                    scene.cardSet = FileUtils.loadCardSet(named: "\(cardSetNamesArray[index].dropLast(5))")
                    scene.scaleMode = .aspectFill
                    let transition = SKTransition.push(with: .left, duration: 0.5)
                    // Present the scene
                    view.presentScene(scene, transition: transition)
                }
            }
        }
        
        buttonPlus = ActionNode(color: UIColor(red: 0.01, green: 0.65-(CGFloat(buttonArrary.count) * multi) + 0.2, blue: 0.05, alpha: 1.0), size: CGSize(width: 158, height: 50))
        buttonPlus.position = CGPoint(x: -84 + (buttonArrary.count)%2 * 163, y: 220 - Int((buttonArrary.count)/2) * 55)
        let cardLabel = SKLabelNode(text: "+")
        cardLabel.verticalAlignmentMode = .center
        cardLabel.fontName = Font.buttonFont
        buttonPlus.addChild(cardLabel)
        
        self.addChild(buttonPlus)
        
        let cardSetLabel = SKLabelNode(text: "Kartenset")
        cardSetLabel.position = CGPoint(x: -160, y: 260)
        cardSetLabel.horizontalAlignmentMode = .left
        cardSetLabel.fontName = Font.buttonFont
        
        //Back Button
        backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)        
        backButton.action = {
            if let scene = SKScene(fileNamed: "MainMenuScene") as? MainMenuScene {
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
        
        self.addChild(backButton)
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
    }
}
