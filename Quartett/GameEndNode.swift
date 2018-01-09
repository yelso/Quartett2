//
//  GameEndNode.swift
//  Quartett
//
//  Created by Niklas Großmann on 09.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameEndNode: SKSpriteNode {
    
    var cell: SKSpriteNode!
    var toSettingsButton: ActionNode!
    var toMainMenuButton: ActionNode!
    var resultLabel: SKLabelNode?
    var statisticLabels = [SKLabelNode]()
    var emojiLabel: SKLabelNode?
    var statisticValueLabels = [SKLabelNode]()
    
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, game: Game) {
        print("init game end node")
        super.init(texture: nil, color: color, size: size)
        
        if game.gameResult == Result.playerWin {
            if let particles = SKEmitterNode(fileNamed: "winParticle") {
                particles.position = CGPoint(x: 0, y: self.size.height/2 + 10)
                particles.zPosition = 6
                addChild(particles)
            }
        } else if game.gameResult == Result.playerLose {
            if let particles = SKEmitterNode(fileNamed: "drawParticle") {
                particles.position = CGPoint(x: 0, y: self.size.height/2 + 10)
                particles.zPosition = 6
                addChild(particles)
            }
        } else {
            if let particles = SKEmitterNode(fileNamed: "drawParticle") {
                particles.position = CGPoint(x: 0, y: self.size.height/2 + 10)
                particles.zPosition = 6
                addChild(particles)
            }
        }
        self.zPosition = 40
        let changeScreenAction = SKAction.moveTo(y: -1000, duration: 0.6)
        self.position = CGPoint(x: 0, y: 0)
        
        
        toSettingsButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        toSettingsButton.position = CGPoint(x: 124, y: -250)
        toSettingsButton.zPosition = 6
        toSettingsButton.setScale(1)
        //toMainMenuButton.isHidden = false
        
        toSettingsButton.action =  {
            if let scene = SKScene(fileNamed: "GameSettingsScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                if let parent = self.parent as? GameScene {
                    parent.view?.presentScene(scene, transition: transition)
                }
            }
        }
        
        toMainMenuButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        toMainMenuButton.position = CGPoint(x: -124, y: -320)
        toMainMenuButton.zPosition = 6
        toMainMenuButton.setScale(1)
        toMainMenuButton.isHidden = false
        
        toMainMenuButton.action = {
            print("onAction!!!hgghghgh")
            
            
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                if let parent = self.parent as? GameScene {
                    parent.view?.presentScene(scene, transition: transition)
                }
            }
           // self.run(SKAction.sequence([changeScreenAction, SKAction.run {
                
             //..   }]))
        }
        cell = setUpCell(withImageNamed: "cell1", color: UIColor.black, blendFactor: 0, position: CGPoint(x:0, y: 0), anchorPoint: CGPoint(x: 0, y: 0))
        
        resultLabel = SKLabelNode(text: "ERGEBNIS")
        resultLabel?.fontName = Font.solutionText
        resultLabel?.fontSize = 60
        resultLabel?.position = CGPoint(x: 0, y: 250)
        
        emojiLabel = SKLabelNode(text: "EMOJI")
        emojiLabel?.fontSize = 90
        emojiLabel?.position = CGPoint(x: 0, y: 135)
        
        statisticLabels.append(SKLabelNode(text: " Deine Punkte: "))
        statisticLabels.append(SKLabelNode(text: "Gegner Punkte: "))
        statisticLabels.append(SKLabelNode(text: "Anzahl Runden: "))
        
        statisticValueLabels.append(SKLabelNode(text: "\(game.player.cards.count)"))
        statisticValueLabels.append(SKLabelNode(text: "\(game.ai.cards.count)"))
        statisticValueLabels.append(SKLabelNode(text: "\(game.rounds.curRound + 1)"))
        
        statisticLabels[0].fontSize = 40
        statisticLabels[1].fontSize = 40
        statisticLabels[2].fontSize = 40
        
        statisticValueLabels[0].fontName = Font.solutionText
        statisticValueLabels[1].fontName = Font.solutionText
        statisticValueLabels[2].fontName = Font.solutionText
        
        statisticValueLabels[0].fontSize = 55
        statisticValueLabels[1].fontSize = 55
        statisticValueLabels[2].fontSize = 55
        
        statisticLabels[0].position = CGPoint(x: -190, y: 0)
        statisticLabels[1].position = CGPoint(x: -190, y: -60)
        statisticLabels[2].position = CGPoint(x: -190, y: -120)
        
        statisticValueLabels[0].position = CGPoint(x: 160, y: 0)
        statisticValueLabels[1].position = CGPoint(x: 160, y: -60)
        statisticValueLabels[2].position = CGPoint(x: 160, y: -120)
        
        statisticValueLabels[0].horizontalAlignmentMode = .right
        statisticValueLabels[1].horizontalAlignmentMode = .right
        statisticValueLabels[2].horizontalAlignmentMode = .right
        
        statisticLabels[0].horizontalAlignmentMode = .left
        statisticLabels[1].horizontalAlignmentMode = .left
        statisticLabels[2].horizontalAlignmentMode = .left
        
        if(game.gameResult! == .playerWin){
            self.resultLabel?.text = "GEWONNEN"
            self.emojiLabel?.text = "😎"
        }else if(game.gameResult! == .playerLose){
            self.resultLabel?.text = "VERLOREN"
            self.emojiLabel?.text = "😭"
        }else if(game.gameResult! == .draw){
            self.resultLabel?.text = "UNENTSCHIEDEN"
            self.emojiLabel?.text = "😐"
            self.resultLabel?.fontSize = (self.resultLabel?.fontSize)! - 8
        }
        
        
        cell.size = CGSize(width: 0, height: 0)
        
        cell.addChild(self.statisticValueLabels[0])
        cell.addChild(self.statisticValueLabels[1])
        cell.addChild(self.statisticValueLabels[2])
        cell.addChild(self.emojiLabel!)
        cell.addChild(self.statisticLabels[0])
        cell.addChild(self.statisticLabels[1])
        cell.addChild(self.statisticLabels[2])
        
        cell.addChild(self.resultLabel!)
        
        cell.addChild(toSettingsButton)
        cell.addChild(toMainMenuButton)
        
//        self.addChild(resultLabel!)
        self.addChild(cell)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpCell(withImageNamed image: String, color: UIColor, blendFactor: CGFloat, position: CGPoint, anchorPoint: CGPoint) -> SKSpriteNode {
        print("using image: \(image)")
        let cell = SKSpriteNode(texture: SKTexture(imageNamed: image))
        cell.color = Color.blue1
        cell.colorBlendFactor = blendFactor
        cell.anchorPoint = anchorPoint
        cell.position = position
        return cell
    }
}
