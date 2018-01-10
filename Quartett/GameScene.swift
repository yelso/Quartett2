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
    var cardCompareNode: CardCompareNode?
    var gameEndNode: GameEndNode?
    var turnLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        cardCompareNode = CardCompareNode(texture: nil, color: Color.background, size: self.size, game: game!)
        cardCompareNode?.delegate = self
        self.addChild(cardCompareNode!)
        cardCompareNode!.zPosition = 5
        cardCompareNode!.position = CGPoint(x: 0, y: 1000)
        selectButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        selectButton.position = CGPoint(x: self.size.width/2 * 0.65, y: self.size.height/2 * 0.85 * -1)
        selectButton.zPosition = 1
        selectButton.setScale(0.01)
        selectButton.isHidden = true
        selectButton.action = {
            self.hideSelectButton()
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (_) in
                self.calculateResultAndShowCompareNode(withIndex: self.selectedIndex)

            })
        }
        cardNode = CardNode(game: game!, color: .clear, size: self.size, position: CGPoint(x: 0, y: 20))
        cardNode?.delegate = self
        pointsNode = GamePointsNode(color: Color.cardMain, size: CGSize(width: self.size.width, height: 40), position: CGPoint(x: 0, y: self.size.height/2 * -1 + 45), game: game!)
        turnLabel = SKLabelNode(text: "Du bist am Zug")
        turnLabel!.verticalAlignmentMode = .bottom
        turnLabel?.horizontalAlignmentMode = .center
        turnLabel!.fontName = Font.buttonFont
        turnLabel!.fontSize = 16
        turnLabel!.position = CGPoint(x: 0, y: cardNode!.size.height/2 + 25)
        
        self.addChild(selectButton)
        self.addChild(cardNode!)
        self.addChild(pointsNode!)
        self.addChild(turnLabel!)
        let closeButton = ActionNode(texture: SKTexture(imageNamed: "closeButton"))
        closeButton.position = CGPoint(x: self.size.width/2 * -0.65, y: self.size.height/2 * 0.85 * -1)
        closeButton.action = {
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                // Set the scene mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .right, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        self.addChild(closeButton)
    }

    func didSelectProperty(atIndex index: Int) {
        selectedIndex = index
        showSelectButton()
    }
    
    func didCloseCardCompareNode() {
        startNextRound()
        if game!.isRunning {
            if game!.isPlayersTurn {
                turnLabel?.text = "Du bist am Zug"
                cardNode?.setInteractionEnabledTo(true)
            } else {
                turnLabel?.text = "Gegner ist am Zug"
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
            cardNode!.update(game!)
            pointsNode!.update(game!)
        } else {
            gameEndNode = GameEndNode(texture: nil, color: Color.background, size: self.size, game: game!)
            gameEndNode!.zPosition = 5
            gameEndNode!.position = CGPoint(x: 0, y: 0)
            self.addChild(gameEndNode!)
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
        let result = game!.calculateRoundResult(forSelectedIndex: index)
        self.cardCompareNode!.position = CGPoint(x: 0, y: 0)
        self.cardCompareNode!.updateDetail(withResult: result, pCard: self.game!.getCurPCard(), aiCard: self.game!.getCurAICard(), game: self.game!, selectedIndex: index)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
