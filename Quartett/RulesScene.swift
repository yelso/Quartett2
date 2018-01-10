//
//  RulesScene.swift
//  Quartett
//
//  Created by Linda Schrödl on 09.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class RulesScene: SKScene {
    
    var backButton: ActionNode!
    var textField: SKLabelNode!
    var ruleLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        textField = SKLabelNode(text: "Es werden Attribute verglichen,\ndas stärkere Attribut gewinnt. \nEs wird gegen den PC gespielt. \nDabei ist immer nur die obere Karte sichtbar. \nDer Gewinner dieser Runde,\nbeginnt die nächste Runde.\nBei Gleichstand landen die Karten \nauf dem Stichhaufen (XX-SH-XX). \nGewonnen hat, wer alle Karten \noder nach Ablauf der Rundenzahl\ndie meisten Karten besitzt.")
        textField.fontSize = 17
        textField.numberOfLines = 0
        textField.lineBreakMode = .byCharWrapping
        textField.position = CGPoint(x: -160, y: 10)
        textField.horizontalAlignmentMode = .left
        textField.fontName = Font.buttonFont
        
        ruleLabel = SKLabelNode(text: "Regeln")
        ruleLabel.position = CGPoint(x: -160, y: 260)
        ruleLabel.horizontalAlignmentMode = .left
        ruleLabel.fontName = Font.buttonFont
        
        //Back Button
        backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        
        self.addChild(textField)
        self.addChild(backButton)
        self.addChild(ruleLabel)
        
        backButton.action = {
            if let scene = SKScene(fileNamed: "MainMenuScene") as? MainMenuScene {
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
    }
    
    
}

