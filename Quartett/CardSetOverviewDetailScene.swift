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
    let posLabel = SKLabelNode(text: "")
    
    override func didMove(to view: SKView) {
        
        cardDetailNodeCenter = CardDetailNode(color: .clear, size: self.size, cardSet: cardSet!, position: CGPoint(x: 0, y: 20))
        self.addChild(cardDetailNodeCenter!)
        
        let nextCardButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        let prevCardButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        let closeButton = ActionNode(texture: SKTexture(imageNamed: "closeButton"))
        posLabel.text = "\(index+1)/\(cardSet!.cards.count)"
        
        nextCardButton.position = CGPoint(x: 100, y: cardDetailNodeCenter!.size.height/2 * -1 - 15)
        prevCardButton.position = CGPoint(x: -100, y: cardDetailNodeCenter!.size.height/2 * -1 - 15)
        posLabel.position = CGPoint(x: 0, y: cardDetailNodeCenter!.size.height/2 * -1 - 15)
        closeButton.position = CGPoint(x: 0, y: cardDetailNodeCenter!.size.height/2 * -1 - 60)
        
        posLabel.fontName = Font.buttonFont
        posLabel.fontSize = 20
        posLabel.horizontalAlignmentMode = .center
        posLabel.verticalAlignmentMode = .center
        
        nextCardButton.action = {
            self.index += 1
            if self.index > self.cardSet!.cards.count-1 {
                self.index = 0
            }
            self.posLabel.text = "\(self.index+1)/\(self.cardSet!.cards.count)"
            self.cardDetailNodeCenter!.update(self.cardSet!, self.cardSet!.cards[self.index])
        }
        
        prevCardButton.action = {
            self.index -= 1
            if self.index < 0 {
                self.index = self.cardSet!.cards.count-1
            }
            self.posLabel.text = "\(self.index+1)/\(self.cardSet!.cards.count)"
            self.cardDetailNodeCenter!.update(self.cardSet!, self.cardSet!.cards[self.index])
            
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
        self.addChild(posLabel)
        self.addChild(closeButton)
        self.addChild(nextCardButton)
        self.addChild(prevCardButton)
    }
}

