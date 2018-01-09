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
        backButton = ActionNode(color: Color.background, size: CGSize(width: 150, height: 50))
        textField = SKLabelNode(text: "Es werden Attribute verglichen,\ndas stärkere Attribut gewinnt. \nEs wird gegen den PC gespielt. \nDabei ist immer nur die obere Karte sichtbar. \nDer Gewinner der dieser Runde,\nbeginnt die nächste Runde.\nBei Gelichstand landen die Karten \nauf dem Stichhaufen (XX-XX-SH). \nGewonnen hat, wer alle Karten \nbesitzt oder nach Ablauf der Rundenzahl\ndie meisten Karten besitzt.")
        textField.fontSize = 15
        textField.numberOfLines = 0
        textField.lineBreakMode = .byCharWrapping
        textField.position = CGPoint(x: -180, y: 0)
        textField.horizontalAlignmentMode = .left
        
        ruleLabel = SKLabelNode(text: "Regeln")
        ruleLabel.position = CGPoint(x: -180, y: 200)
        ruleLabel.horizontalAlignmentMode = .left
        
        
        
        //Back Button
        let endLabel = SKLabelNode(text: "< Zurück")
        backButton.position = CGPoint(x: -130, y: -320)
        endLabel.fontSize = 25
        endLabel.verticalAlignmentMode = .center
        backButton.addChild(endLabel)
        
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

