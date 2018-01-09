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
    var cardCompareNode : CardCompareNode?
    
    override func didMove(to view: SKView) {
        cardCompareNode = CardCompareNode(texture: nil, color: Color.background, size: self.size, game: game!)
        cardCompareNode?.delegate = self
        self.addChild(cardCompareNode!)
        cardCompareNode!.zPosition = 5
        cardCompareNode!.position = CGPoint(x: 0, y: 1000)
        selectButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        selectButton.position = CGPoint(x: 124, y: -290)
        selectButton.zPosition = 1
        selectButton.setScale(0.01)
        selectButton.isHidden = true
        selectButton.action = {
            print("onAction!!!")
            self.calculateResultAndShowCompareNode(withIndex: self.selectedIndex)
        }
        
        cardNode = CardNode(game: game!, color: .clear, size: self.size, position: CGPoint(x: 0, y: 20))
        cardNode?.delegate = self
        pointsNode = GamePointsNode(color: Color.cardMain, size: CGSize(width: self.size.width, height: 40), position: CGPoint(x: 0, y: self.size.height/2 * -1 + 45))
        print(self.view!.frame.width)
        
        self.addChild(selectButton)
        self.addChild(cardNode!)
        self.addChild(pointsNode!)
    }

    func didSelectProperty(atIndex index: Int) {
        selectedIndex = index
        showSelectButton()
    }
    
    func didCloseCardCompareNode() {
        if game!.isPlayersTurn {
            cardNode?.setInteractionEnabledTo(true)
        } else {
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false, block: { (_) in
                self.cardNode!.propertyGroupNodes[self.game!.getAiSelection()].handleTouch()
                self.cardNode!.propertyGroupNodes[self.game!.getAiSelection()].isHighlighted = true
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                    self.cardNode!.propertyGroupNodes[self.game!.getAiSelection()].handleTouchEndInside()
                    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
                        self.calculateResultAndShowCompareNode(withIndex: self.game!.getAiSelection())
                    })
                })
            })
        }
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
        if game!.nextRound() {
            print("updating values")
            cardNode!.update(game!)
            pointsNode!.update()
        } else {
            // TODO
            print("GAME_END")
        }
    }
    
    func hideSelectButton() {
        selectButton.isUserInteractionEnabled = false
        let scaleUpAction = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDownAction = SKAction.scale(to: 0.01, duration: 0.15)
        selectButton.run(SKAction.sequence([scaleUpAction,  scaleDownAction, SKAction.run({self.selectButton.isHidden = true})]))
    }
    
    func calculateResultAndShowCompareNode(withIndex index: Int) {
        cardNode?.setInteractionEnabledTo(false) // todo fix exception when playing too fast
        self.hideSelectButton()
        let result = game!.calculateResult(forSelectedIndex: index)
        self.cardCompareNode!.position = CGPoint(x: 0, y: 0)
        self.cardCompareNode!.updateDetail(withResult: result, pCard: self.game!.getCurPCard(), aiCard: self.game!.getCurAICard(), game: self.game!, selectedIndex: index)
        
        self.startNextRound()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
}
