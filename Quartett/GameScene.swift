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
    override func didMove(to view: SKView) {
        gamePointsBackgroundColor = self.childNode(withName: "gamePointsBackgroundColor") as! SKSpriteNode
        gamePointsLabel = self.childNode(withName: "gamePointsLabel") as! SKLabelNode
    
        gamePointsLabel.text = playerCardAmount + " : " + aiCardAmount + " : " + allCardAmount
        var labels = [SKLabelNode]()
        var values = [SKLabelNode]()
        var selectors = [GroupActionNode]()
        
        for index in 1...5 {
            var node = SKLabelNode(text: "property\(index)")
            node.position = CGPoint(x: -220, y: -60 * index)
            var valueNode = SKLabelNode(text: "value\(index)")
            valueNode.position = CGPoint(x: 240, y: -60 * index)
            var selector = GroupActionNode(color: UIColor.clear, size: CGSize(width: 600, height: 58))
            selector.anchorPoint = CGPoint(x: 0, y: 0.35)
            selector.position = CGPoint(x:-300, y: -60 * index)
            labels.append(node)
            values.append(valueNode)
            selectors.append(selector)
            if (selectors.count > 0) {
                selectors[0].addToGroup(selector)
            }
            self.addChild(selector)
            self.addChild(node)
            self.addChild(valueNode)
        }
        selectors[0].action = {
            //GroupActionNode.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 1))
        }
        // TODO: group action
        // Get label node from scene and store it for use later
        /*self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        */
    }
    /*
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    */
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
