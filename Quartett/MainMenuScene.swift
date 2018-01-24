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
    
    //let queue = DispatchQueue.global()

    var startButton: ActionNode!
    var cardSetButton: ActionNode!
    var rulesButton: ActionNode!
    var storeButton: ActionNode!
    var logo: SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        
        startButton = ActionNode(color: Color.midnightOrange, size: CGSize(width: 150, height: 50))
        cardSetButton = ActionNode(color: Color.darkOrange, size: CGSize(width: 150, height: 50))
        rulesButton = ActionNode(color: Color.softOrange, size: CGSize(width: 150, height: 50))
        storeButton = ActionNode(color: Color.lightOrange, size: CGSize(width: 150, height: 50))
        
        logo = SKSpriteNode(texture: SKTexture(imageNamed: "logo_bunt"))
        logo?.position = CGPoint(x: 0, y: 170)
        self.addChild(logo!)
        
        let startLabel = SKLabelNode(text: "Start")
        startButton.position = CGPoint(x: 0, y: 30)
        startLabel.fontSize = 35
        startLabel.fontName = Font.buttonFont
        startLabel.verticalAlignmentMode = .center
        startButton.addChild(startLabel)
        self.addChild(startButton)
        
        let cardSetLabel = SKLabelNode(text: "Karten")
        cardSetButton.position = CGPoint(x: 0, y: -35)
        cardSetLabel.fontSize = 35
        cardSetLabel.fontName = Font.buttonFont
        cardSetLabel.verticalAlignmentMode = .center
        cardSetButton.addChild(cardSetLabel)
        self.addChild(cardSetButton)
        
        let rulesLabel = SKLabelNode(text: "Regeln")
        rulesButton.position = CGPoint(x: 0, y: -100)
        rulesLabel.fontSize = 35
        rulesLabel.fontName = Font.buttonFont
        rulesLabel.verticalAlignmentMode = .center
        rulesButton.addChild(rulesLabel)
        self.addChild(rulesButton)
        
        let storeLabel = SKLabelNode(text: "Store")
        storeButton.position = CGPoint(x: 0, y: -165)
        storeLabel.fontSize = 35
        storeLabel.fontName = Font.buttonFont
        storeLabel.verticalAlignmentMode = .center
        storeButton.addChild(storeLabel)
        self.addChild(storeButton)
        
        
        startButton.action =  {
            if let scene = SKScene(fileNamed: "GameSettingsScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        cardSetButton.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        rulesButton.action = {
            if let scene = SKScene(fileNamed: "RulesScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        
        storeButton.action = {
            if let scene = SKScene(fileNamed: "StoreScene") {
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
    }
}
