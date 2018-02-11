//
//  CardSetOverviewDetailScene.swift
//  Quartett
//
//  Created by Linda Schrödl on 29.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class CardSetOverviewDetailScene: SKScene {
    var img: SKSpriteNode?
    var imgName = "bikes2"
    
    var cardSet: CardSet?
    var cardDetailNodeCenter: CardDetailNode?
    let swipeLeftRec = UIPanGestureRecognizer()
    var index: Int = 0
    let indexLabel = SKLabelNode(text: "")
    
    override func didMove(to view: SKView) {
        cardDetailNodeCenter = CardDetailNode(color: .clear, size: self.size, cardSet: cardSet!, position: CGPoint(x: 0, y: 0))
        self.addChild(cardDetailNodeCenter!)
       
        let nextCardButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        let prevCardButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        let closeButton = ActionNode(texture: SKTexture(imageNamed: "closeButton"))
        indexLabel.text = "\(index+1)/\(cardSet!.cards!.count)"
        
        nextCardButton.position = CGPoint(x: 100, y: -290) //cardDetailNodeCenter!.size.height/2 * -1 - 15)
        prevCardButton.position = CGPoint(x: -100, y: -290) //cardDetailNodeCenter!.size.height/2 * -1 - 15)
        indexLabel.position = CGPoint(x: 0, y: -290)//cardDetailNodeCenter!.size.height/2 * -1 - 15)
        closeButton.position = CGPoint(x: 0, y: -325)//cardDetailNodeCenter!.size.height/2 * -1 - 60)
        
        indexLabel.fontName = Font.buttonFont
        indexLabel.fontSize = 20
        indexLabel.horizontalAlignmentMode = .center
        indexLabel.verticalAlignmentMode = .center
        
        nextCardButton.action = {
            self.index += 1
            if self.index > self.cardSet!.cards!.count-1 {
                self.index = 0
            }
            self.indexLabel.text = "\(self.index+1)/\(self.cardSet!.cards!.count)"
            self.cardDetailNodeCenter!.update(self.cardSet!, self.cardSet!.cards![self.index])
        }
        
        prevCardButton.action = {
            self.index -= 1
            if self.index < 0 {
                self.index = self.cardSet!.cards!.count-1
            }
            self.indexLabel.text = "\(self.index+1)/\(self.cardSet!.cards!.count)"
            self.cardDetailNodeCenter!.update(self.cardSet!, self.cardSet!.cards![self.index])
            
        }
        
        closeButton.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewScene") {
                // Set the scene mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .right, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        self.addChild(indexLabel)
        self.addChild(closeButton)
        self.addChild(nextCardButton)
        self.addChild(prevCardButton)
    }
}

