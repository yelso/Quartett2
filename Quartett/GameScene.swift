//
//  GameScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, CardDelegate {
    
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
    var cardNode: CardNode?
    var pointsNode: GamePointsNode?
    var selectedIndex = 0
    
    override func didMove(to view: SKView) {
        
        gamePointsBackgroundColor = self.childNode(withName: "gamePointsBackgroundColor") as! SKSpriteNode
        gamePointsLabel = self.childNode(withName: "gamePointsLabel") as! SKLabelNode
    
        gamePointsLabel.text = playerCardAmount + " : " + aiCardAmount + " : " + allCardAmount
        selectButton = self.childNode(withName: "selectButton") as! ActionNode
        selectButton.isHidden = true
        selectButton.zPosition = 1
        
        cardNode = CardNode(game: game!, color: .clear, size: self.size, position: CGPoint(x: 0, y: 40))
        cardNode?.delegate = self
        pointsNode = GamePointsNode(color: Color.cardMain, size: CGSize(width: self.size.width, height: 80), position: CGPoint(x: 0, y: self.size.height/2 * -1 + 40))
        print(self.view!.frame.width)
        
        self.addChild(cardNode!)
        self.addChild(pointsNode!)
        
        let myHud = CardCompareNode(texture: nil, color: UIColor.clear, size: self.size)
        myHud.setVisible(to: false)
        self.addChild(myHud)
    }

    func didSelectProperty(atIndex index: Int) {
        selectedIndex = index
        showSelectButton()
    }
    
    func showSelectButton() {
        guard selectButton.isHidden else { return }
        selectButton.isHidden = false
        // animation
        selectButton.action = {
            print("onAction!!!")
            self.startNextRound()
        }
    }
    
    func startNextRound() {
        game!.calculateResult(forSelectedIndex: selectedIndex)
        if game!.nextRound() {
            print("updating values")
            cardNode!.update(game!)
            pointsNode!.update()
        } else {
            // TODO
        }
    }
    
    func hideSelectButton() {
        selectButton.removeAllActions()
        selectButton.isHidden = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
