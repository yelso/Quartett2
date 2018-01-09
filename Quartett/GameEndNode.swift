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
    var toMainMenuButton: ActionNode!
    var playAgainButton: ActionNode!
    var resultLabel: SKLabelNode?
    
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, game: Game) {
        super.init(texture: nil, color: color, size: size)

        let changeScreenAction = SKAction.moveTo(y: -1000, duration: 0.6)
        
        
        
        toMainMenuButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        toMainMenuButton.position = CGPoint(x: 124, y: -250)
        toMainMenuButton.zPosition = 6
        toMainMenuButton.setScale(0.01)
        toMainMenuButton.isHidden = false
        
        toMainMenuButton.action = {
            print("onActigfgfgon!!!")
           // self.run(SKAction.sequence([changeScreenAction, SKAction.run {
                
             //   }]))
        }
        
        playAgainButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        playAgainButton.position = CGPoint(x: -124, y: -250)
        playAgainButton.zPosition = 6
        playAgainButton.setScale(0.01)
        playAgainButton.isHidden = false
        
        playAgainButton.action = {
            print("onAction!!!hgghghgh")
           // self.run(SKAction.sequence([changeScreenAction, SKAction.run {
                
             //..   }]))
        }
        cell = setUpCell(withImageNamed: "cell1", color: UIColor.black, blendFactor: 0, position: CGPoint(x:0, y: 0), anchorPoint: CGPoint(x: 0.5, y: 0.5))
        resultLabel?.text = "ERGEBNIS"
        resultLabel?.position = CGPoint(x: 0, y: 0)
        if(game.gameResult! == .playerWin){
            self.resultLabel?.text = "GEWONNEN!!!"
        }else if(game.gameResult! == .playerLose){
            self.resultLabel?.text = "VERLOREN"
        }else if(game.gameResult! == .draw){
            self.resultLabel?.text = "UNENTSCHIEDEN"
            self.resultLabel?.fontSize = (self.resultLabel?.fontSize)! - 8
        }
        
        
        cell.size = CGSize(width: 414, height: 41)
        
//        cell.addChild(resultLabel!)
        
        cell.addChild(toMainMenuButton)
        cell.addChild(playAgainButton)
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
