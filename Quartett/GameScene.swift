//
//  GameScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
   // private var label : SKLabelNode?
   // private var spinnyNode : SKShapeNode?
    var game: Game?
    var gamePointsBackgroundColor: SKSpriteNode!
    var gamePointsLabel: SKLabelNode!
    var playerCardAmount = "27"
    var aiCardAmount = "05"
    var allCardAmount = "02"
    var selectors = [GroupActionNode]()
    var selectButton: ActionNode!
    var cardImage: SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "tuning3"))
    override func didMove(to view: SKView) {
        let cardNode = SKSpriteNode(color: .clear, size: self.size)
        cardImage.texture = SKTexture(imageNamed: game!.cardSet!.name.lowercased() + String(game!.player.currentCard!.images[0].filename.dropLast(4)))
        cardNode.addChild(cardImage)
        cardImage.position = CGPoint(x: 0, y: 106.5)
        cardImage.scale(to: CGSize(width: 300, height: 195))
        gamePointsBackgroundColor = self.childNode(withName: "gamePointsBackgroundColor") as! SKSpriteNode
        gamePointsLabel = self.childNode(withName: "gamePointsLabel") as! SKLabelNode
    
        gamePointsLabel.text = playerCardAmount + " : " + aiCardAmount + " : " + allCardAmount
        selectButton = self.childNode(withName: "selectButton") as! ActionNode
        selectButton.isHidden = true
        var properties = [(label: SKLabelNode, value: SKLabelNode)]()
        //var values = [SKLabelNode]()
        
        let maxProperties = game!.player.currentCard!.values.count
        for index in 0...maxProperties {
            
            if index == 0 {
                let propertyNode = SKSpriteNode(texture: SKTexture(imageNamed: "propertyCellEndBackground"))
                propertyNode.zRotation = .pi
                propertyNode.position = CGPoint(x:0, y: 226)
                let label = SKLabelNode(text: game!.player.currentCard!.name)
                label.position = CGPoint(x: (propertyNode.size.width/2) * 0.95 , y: 0)
                label.zRotation = .pi
                label.horizontalAlignmentMode = .left
                label.verticalAlignmentMode = .center
                label.fontSize = 24
                label.fontColor = .black
                label.fontName = "Helvetica Neue Light"
                propertyNode.addChild(label)
                cardNode.addChild(propertyNode)
            } else {
                let imageNamed = index == maxProperties ? "propertyCellEndBackground" : "propertyCellBackground"
                let propertyNode = GroupActionNode(texture: SKTexture(imageNamed: imageNamed))
                propertyNode.color = UIColor(red:1.00, green:0.93, blue:0.62, alpha:1.0)
                propertyNode.colorBlendFactor = 0
                propertyNode.anchorPoint = CGPoint(x: 0.5, y: 0.35)
                propertyNode.position = CGPoint(x:0, y: (-20 + (-42 * (index-1))))
                //values.append(valueNode)
                selectors.append(propertyNode)
            
                let cardProperty = game!.cardSet!.getProperty(withId: game!.player.currentCard!.values[index-1].propertyId)!
                var valueText = "VALUE"
                if cardProperty.unit.starts(with: "1") {
                    let unit = cardProperty.unit.dropFirst()
                    valueText = "\(game!.player.currentCard!.values[index-1].value)\(unit)"
                } else {
                    valueText = "\(game!.player.currentCard!.values[index-1].value) \(cardProperty.unit)"
                }
                let node = SKLabelNode(text: cardProperty.text!)
                node.position = CGPoint(x: (propertyNode.size.width/2) * 0.95 * -1 , y: 0)
                node.horizontalAlignmentMode = .left
                let valueNode = SKLabelNode(text: valueText)
                valueNode.fontColor = .black
                valueNode.position = CGPoint(x: (propertyNode.size.width/2) * 0.95, y: 0)
                node.fontColor = .black
                node.fontSize = 16
                valueNode.fontSize = 16
                valueNode.horizontalAlignmentMode = .right
                properties.append((label: node, value: valueNode))
            
                propertyNode.addChild(node)
                propertyNode.addChild(valueNode)
                cardNode.addChild(propertyNode)
            }
        }
        cardNode.position = CGPoint(x: 0, y: 20)
        self.addChild(cardNode)
        selectors[0].setUpGroup(selectors)

        for propertyNode in selectors {
            propertyNode.action = {
                self.selectButton.isHidden = false
            }
            propertyNode.onTouchEnd = {
                let color = SKAction.colorize(with: .green, colorBlendFactor: 0.25, duration: 0.2)
                propertyNode.run(color)
                
            }
            propertyNode.onTouchEndGroup = {
                for member in propertyNode.group {
                    member.colorBlendFactor = 0
                    member.color = UIColor(red:1.00, green:0.93, blue:0.62, alpha:1.0)
                }
            }
            propertyNode.customAnimationEnabled = true
        }
        
        let myHud = CardCompareNode(texture: nil, color: UIColor.clear, size: self.size)
        myHud.setVisible(to: false)
        self.addChild(myHud)
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
