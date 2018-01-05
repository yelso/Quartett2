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
    
    var game: Game?
    var selectButton: ActionNode!
    var cardNode: CardNode?
    var pointsNode: GamePointsNode?
    var selectedIndex = 0
    
    override func didMove(to view: SKView) {
        selectButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        selectButton.position = CGPoint(x: 124, y: -250)
        selectButton.zPosition = 1
        selectButton.setScale(0.01)
        selectButton.isHidden = true
        selectButton.action = {
            print("onAction!!!")
            self.startNextRound()
            self.hideSelectButton()
        }
        
        cardNode = CardNode(game: game!, color: .clear, size: self.size, position: CGPoint(x: 0, y: 40))
        cardNode?.delegate = self
        pointsNode = GamePointsNode(color: Color.cardMain, size: CGSize(width: self.size.width, height: 40), position: CGPoint(x: 0, y: self.size.height/2 * -1 + 60))
        print(self.view!.frame.width)
        
        self.addChild(selectButton)
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
        let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.15)
        let scaleNormalAction = SKAction.scale(to: 1.0, duration: 0.15)
        let scaleDownAction = SKAction.scale(to: 0.8, duration: 0.15)
        selectButton.run(SKAction.sequence([scaleUpAction, scaleDownAction, scaleNormalAction, SKAction.run({self.selectButton.isUserInteractionEnabled = true})]))
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
        let scaleUpAction = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDownAction = SKAction.scale(to: 0.01, duration: 0.15)
        selectButton.run(SKAction.sequence([SKAction.run({self.selectButton.isUserInteractionEnabled = false}), scaleUpAction,  scaleDownAction, SKAction.run({self.selectButton.isHidden = true})]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
