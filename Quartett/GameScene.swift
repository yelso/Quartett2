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
    var gamePointsBackgroundColor: SKSpriteNode!
    var gamePointsLabel: SKLabelNode!
    var playerCardAmount = "27"
    var aiCardAmount = "05"
    var allCardAmount = "02"
    var selectors = [GroupActionNode]()
    var selectButton: ActionNode!
    override func didMove(to view: SKView) {
        
        gamePointsBackgroundColor = self.childNode(withName: "gamePointsBackgroundColor") as! SKSpriteNode
        gamePointsLabel = self.childNode(withName: "gamePointsLabel") as! SKLabelNode
    
        gamePointsLabel.text = playerCardAmount + " : " + aiCardAmount + " : " + allCardAmount
        selectButton = self.childNode(withName: "selectButton") as! ActionNode
        selectButton.isHidden = true
        var properties = [(label: SKLabelNode, value: SKLabelNode)]()
        //var values = [SKLabelNode]()
        
        let maxProperties = 5
        for index in 1...maxProperties {
            
            let imageNamed = index == maxProperties ? "propertyCellEndBackground" : "propertyCellBackground"
            let propertyNode = GroupActionNode(texture: SKTexture(imageNamed: imageNamed))
            propertyNode.color = UIColor(red:1.00, green:0.93, blue:0.62, alpha:1.0)
            propertyNode.colorBlendFactor = 0
            propertyNode.anchorPoint = CGPoint(x: 0.5, y: 0.35)
            propertyNode.position = CGPoint(x:0, y: -72 * index)
            //values.append(valueNode)
            selectors.append(propertyNode)
            
            
            let node = SKLabelNode(text: "property\(index)")
            node.position = CGPoint(x: -250, y: 0)
            node.horizontalAlignmentMode = .left
            let valueNode = SKLabelNode(text: "value\(index)")
            valueNode.fontColor = .black
            valueNode.position = CGPoint(x: 250, y: 0)
            node.fontColor = .black
            valueNode.horizontalAlignmentMode = .right
            properties.append((label: node, value: valueNode))
            
            propertyNode.addChild(node)
            propertyNode.addChild(valueNode)
            self.addChild(propertyNode)
        }
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
