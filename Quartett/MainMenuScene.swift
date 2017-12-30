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
    
    var startButton: ActionNode!
    var cardsOverviewButton: ActionNode!
    var rulesButton: ActionNode!
    override func didMove(to view: SKView) {
        
        cardsOverviewButton = self.childNode(withName: "cardsOverviewButton") as! ActionNode
        cardsOverviewButton.action = {
            if let scene = SKScene(fileNamed: "CardSetOverviewScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
                
            }
        }
        
        startButton = self.childNode(withName: "startButton") as! ActionNode
        startButton.action = {
            if let scene = SKScene(fileNamed: "GameSettingsScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        
        }
        startButton.onTouch = {self.startButton?.run(SKAction.scale(to: 0.95, duration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0))
        }
        
        startButton.onTouchEnd = {
            self.startButton?.run(SKAction.scale(to: 1.0, duration: 0.03))
        }
        
        rulesButton = self.childNode(withName: "rulesButton") as! ActionNode
        
        var nodes = [SKSpriteNode]()
        for index in 0..<3 {
            var node = SKSpriteNode(texture: SKTexture(image: UIImage(named: "shine5")!))
            if (index == 1) {
                node = SKSpriteNode(texture: SKTexture(image: UIImage(named: "shine6")!))
            } else if (index == 2) {
                node = SKSpriteNode(texture: SKTexture(image: UIImage(named: "shine7")!))
            }
            node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            node.position = CGPoint(x: 0, y: 200)
            
            node.setScale(0.45)
            node.zRotation = CGFloat(Double.pi/1.5 * Double(index))
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 5)))
            
            nodes.append(node)
            self.addChild(node)
        }
        
        for index in 0..<14 {
            var node = SKSpriteNode(texture: SKTexture(image: UIImage(named: "shine2")!))
            if (index%3 == 0) {
                node = SKSpriteNode(texture: SKTexture(image: UIImage(named: "shine3")!))
            } else if (index%3 == 1) {
                node = SKSpriteNode(texture: SKTexture(image: UIImage(named: "shine4")!))
            }
            node.position = CGPoint(x: 0, y: 200)
            node.anchorPoint = CGPoint(x: 0.5, y: 0)
            node.setScale(0.45)
            node.zRotation = CGFloat(Double.pi/7 * Double(index))
            let value = CGFloat(0.3+(Double(arc4random_uniform(5))*0.1))
            let time = TimeInterval(5+arc4random_uniform(6))
            node.run(SKAction.repeatForever(
                SKAction.group([SKAction.rotate(byAngle: 1, duration: time), SKAction.sequence([SKAction.scale(to: value, duration: time/2), SKAction.scale(to: 0.45, duration: time/2)])])
            ))
            
            nodes.append(node)
            self.addChild(node)
        }
        
        let label = SKSpriteNode(texture: SKTexture(image: UIImage(named:"logo_bianco-1")!))
        label.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        label.position = CGPoint(x: 0, y: 200)
        label.setScale(0.5)
        self.addChild(label)
        
    }
  
}
