//
//  CardCompareNode.swift
//  Quartett
//
//  Created by Puja Dialehabady on 02.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class CardCompareNode: SKSpriteNode {
    var delegate: CardDelegate?
    
    var cell: SKSpriteNode!
    var blackCell: SKSpriteNode!
    private var nextRoundButton: ActionNode!
    var img1: SKSpriteNode?
    var img2: SKSpriteNode?
    var titleLabel: SKLabelNode?
    var labels = [SKLabelNode]()
    var timers = [Timer]()
    var propertyCellNodes = [SKSpriteNode]()
    

    // nil, Color.background, self.size, game!
    init(texture: SKTexture?, color: UIColor, size: CGSize, game: Game) {
        print("init card compare node")
        super.init(texture: texture, color: color, size: size)
        img1 = SKSpriteNode(texture: SKTexture(imageNamed: "tuning8"))
        img2 = SKSpriteNode(texture: SKTexture(imageNamed: "tuning7"))
        img1!.position = CGPoint(x: -86, y: 200)
        img2!.position = CGPoint(x: 86, y: -200)
        img1!.size = CGSize(width: 572, height: 370)
        img2!.size = CGSize(width: 572, height: 370)
        
//        blackCell?.position = CGPoint(x: 0, y: 0)
//        blackCell?.size = CGSize(width: 600, height: 800)
//        blackCell?.color = UIColor.black
//        blackCell?.zPosition = 6
//        blackCell!.addChild(SKNode())
//
//        //
//        self.addChild(blackCell)
        self.addChild(img2!)
        self.addChild(img1!)
        
        let changeScreenAction = SKAction.moveTo(y: -1000, duration: 0.6)
        
        nextRoundButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        nextRoundButton.position = CGPoint(x: 124, y: -250)
        nextRoundButton.zPosition = 6
        nextRoundButton.setScale(0.01)
        nextRoundButton.isHidden = false
        nextRoundButton.action = {
            print("onAction!!1!")
            for timer in self.timers {
                timer.invalidate()
            }
            for label in self.labels {
                label.removeAllActions()
            }
            self.img1?.removeAllActions()
            self.img2?.removeAllActions()
            self.timers.removeAll()
            self.hideNextRoundButton()
            self.run(SKAction.sequence([changeScreenAction, SKAction.run {
                self.delegate?.didCloseCardCompareNode()
            }]))
        }
        
        cell = setUpCell(withImageNamed: "cell1", color: UIColor.black, blendFactor: 0, position: CGPoint(x:0, y: 0), anchorPoint: CGPoint(x: 0.5, y: 0.5))
        cell.size = CGSize(width: 414, height: 41)
        
        
        
        let labelTuple = setUpLabels(for: cell, selectedIndex: 0)
        labels.append(labelTuple.name)
        labels.append(labelTuple.valueP)
        labels.append(labelTuple.valueAI)
        cell.addChild(labelTuple.name)
        cell.addChild(labelTuple.valueP)
        cell.addChild(labelTuple.valueAI)
        
        self.addChild(cell)
        self.addChild(nextRoundButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //returns name and values of two cards to compare them
    func getPropertyNameAndValuesOfTwoCards(forIndex index: Int, _ game: Game, playerCard: Card, aiCard: Card) -> (name: String, valueP: String, valueAi: String) {
        
        let propertyP = game.cardSet!.getProperty(withId: playerCard.values[index].propertyId)!
        let propertyAi = game.cardSet!.getProperty(withId: aiCard.values[index].propertyId)!
        
        return (propertyP.text!, game.getCurPCard().values[index].value + propertyP.getStylizedUnit(), aiCard.values[index].value + propertyAi.getStylizedUnit())
    }
    
    func resetActions(){
        img1!.position = CGPoint(x: -80, y: 200)
        img2!.position = CGPoint(x: 80, y: -200)
        labels[0].position = CGPoint(x: 0 , y: 0)
        labels[0].setScale(1)
        labels[0].text = "VS"
        labels[0].fontSize = 50
        labels[1].position = CGPoint(x: -600 , y: 50)
        labels[2].position = CGPoint(x: 600 , y: -50)
        removeAllActions()
    }
    
    func allActions(){
        let moveValue1RightAction = SKAction.moveTo(x: -200, duration: 0.6)
        let moveValue2RightAction = SKAction.moveTo(x: 70, duration: 6)
        let moveValue3RightAction = SKAction.moveTo(x: 250, duration: 0.3)
        let moveValuePBackAction = SKAction.moveTo(x: (cell.size.width/2) * 3 * -1, duration: 0)
        labels[1].run(SKAction.sequence([moveValue1RightAction, moveValue2RightAction, moveValue3RightAction, moveValuePBackAction]))
        
        let moveValue1LeftAction = SKAction.moveTo(x: 250, duration: 0.6)
        let moveValue2LeftAction = SKAction.moveTo(x: -70, duration: 6)
        let moveValue3LeftAction = SKAction.moveTo(x: -250, duration: 0.3)
        let moveValueAIBackAction = SKAction.moveTo(x: (cell.size.width/2) * 3, duration: 0)
        labels[2].run(SKAction.sequence([moveValue1LeftAction, moveValue2LeftAction, moveValue3LeftAction, moveValueAIBackAction]))
        
        let moveimg1RightAction = SKAction.moveTo(x: 40, duration: 11)
        let moveimg2LeftAction = SKAction.moveTo(x: -40, duration: 11)
        
        img1!.run(moveimg1RightAction)
        img2!.run(moveimg2LeftAction)
    }
    func updateDetail(withResult result: Result, pCard: Card, aiCard: Card, game: Game, selectedIndex: Int) {
        resetActions()
        
        
        
        titleLabel?.text = pCard.name + " " + aiCard.name
        //cardToCompare.images = [winner.images, loser.images]
        img1?.texture = SKTexture(imageNamed: game.getCSPCardImageNameWithoudSuffix(atIndex: 0))
        img2?.texture = SKTexture(imageNamed: game.getCSAICardImageNameWithoudSuffix(atIndex: 0))
        
        labels[1].text = getPropertyValueAndUnit(forIndex: selectedIndex, game, isAi: false)
        labels[2].text = getPropertyValueAndUnit(forIndex: selectedIndex, game, isAi: true)
        
        
        //if the human player wins the round (pic and values are left side)(winnerpic is above loser pic) else ki wins round
        if result == Result.playerWin {
        
            let setLabelSizeTo0Action = SKAction.scale(to: 0, duration: 0.5)
            let resetLabelSizeAction = SKAction.scale(to: 1, duration: 0.5)
            timers.append(Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (_) in
                self.labels[0].run(SKAction.sequence([setLabelSizeTo0Action, SKAction.run {
                    self.labels[0].text = "GEWONNEN"
                    self.labels[0].run(resetLabelSizeAction)
                    }]))
            })
        } else if result == Result.playerLose {
            let setLabelSizeTo0Action = SKAction.scale(to: 0, duration: 0.5)
            let resetLabelSizeAction = SKAction.scale(to: 1, duration: 0.5)
            timers.append(Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (_) in
                self.labels[0].run(SKAction.sequence([setLabelSizeTo0Action, SKAction.run {
                    self.labels[0].text = "VERLOREN"
                    self.labels[0].run(resetLabelSizeAction)
                    }]))
            })
        } else { // draw
            let setLabelSizeTo0Action = SKAction.scale(to: 0, duration: 0.5)
            let resetLabelSizeAction = SKAction.scale(to: 1, duration: 0.5)
            timers.append(Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (_) in
                self.labels[0].run(SKAction.sequence([setLabelSizeTo0Action, SKAction.run {
                    let temp = self.labels[0].fontSize
                    print(self.labels[0].fontSize)
                    self.labels[0].fontSize = temp - 8
                    self.labels[0].text = "UNENTSCHIEDEN"
                    self.labels[0].run(resetLabelSizeAction)
                    }]))
            })
        }
        allActions()
        
        timers.append(Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { (_) in
            print("timer in card compare node")
            self.nextRoundButton.action()
            
        })
        timers.append(Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
            self.showNextRoundButton()
            
        })
        
        
    }
    func showNextRoundButton() {
        //guard nextRoundButton.isHidden else { return }
        //nextRoundButton.isHidden = false
        // animation
        let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.15)
        let scaleNormalAction = SKAction.scale(to: 1.0, duration: 0.15)
        let scaleDownAction = SKAction.scale(to: 0.8, duration: 0.15)
        self.nextRoundButton.isHidden = false
        nextRoundButton.run(SKAction.sequence([scaleUpAction, scaleDownAction, scaleNormalAction, SKAction.run({self.nextRoundButton.isUserInteractionEnabled = true})]))
    }
    
    func hideNextRoundButton() {
        let scaleUpAction = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDownAction = SKAction.scale(to: 0.01, duration: 0.15)
        nextRoundButton.run(SKAction.sequence([SKAction.run({self.nextRoundButton.isUserInteractionEnabled = false}), scaleUpAction,  scaleDownAction, SKAction.run({self.nextRoundButton.isHidden = true})]))
        self.resetActions()
        
    }
    
    func setUpCell(withImageNamed image: String, color: UIColor, blendFactor: CGFloat, position: CGPoint, anchorPoint: CGPoint) -> SKSpriteNode {
        print("using image: \(image)")
        let cell = SKSpriteNode(texture: SKTexture(imageNamed: image))
        cell.color = color
        cell.colorBlendFactor = blendFactor
        cell.anchorPoint = anchorPoint
        cell.position = position
        return cell
    }
    // add names on the card
    
//    func setUpCardNames(for game: Game){
//        let cellName1 = SKSpriteNode()
//        cellName1.position = CGPoint(x: 0, y: 0)
//        cardPName = game.getCurPCard().name
//        cardAIName = game.getCurAICard().name
//        cellName1.addChild(cardPName)
//        cellName1.addChild(cardAIName)
//
//
//    }
    
    func setUpLabels(for cell: SKSpriteNode, selectedIndex: Int) -> (name: SKLabelNode, valueP: SKLabelNode, valueAI: SKLabelNode) {
        let nameLabel = SKLabelNode(text: "VS")//propertyNameAndValueOfTwoCards.name)
        nameLabel.position = CGPoint(x: 0 , y: 0)
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.verticalAlignmentMode = .center
        nameLabel.fontColor = Color.cardText
        nameLabel.fontName = Font.solutionText
        nameLabel.fontSize = 50
        
        
        // values from PlayerCard
        let valuePLabel = SKLabelNode(text: "VALUE_P")
        
        valuePLabel.position = CGPoint(x: (cell.size.width/2) * 3 * -1 , y: 50)
        valuePLabel.horizontalAlignmentMode = .left
        valuePLabel.verticalAlignmentMode = .center
        valuePLabel.fontColor = Color.cardText
        valuePLabel.fontName = Font.solutionText2
        valuePLabel.fontSize = 50
        
        // values from AICard
        let valueAILabel = SKLabelNode(text: "VALUE_AI")
        valueAILabel.position = CGPoint(x: (cell.size.width/2) * 3, y: -50)
        valueAILabel.horizontalAlignmentMode = .right
        valueAILabel.verticalAlignmentMode = .center
        valueAILabel.fontColor = Color.cardText
        valueAILabel.fontName = Font.solutionText2
        valueAILabel.fontSize = 50
        
        return (name: nameLabel, valueP: valuePLabel, valueAI: valueAILabel)
    }
    
    func setVisible(to visible: Bool) {
        if visible {
            isHidden = false
        } else {
            isHidden = true
        }
    }
    
    func getPropertyValueAndUnit(forIndex index: Int, _ game: Game, isAi: Bool) -> String {
        let property = game.cardSet!.getProperty(withId: (isAi ? game.getCurAICard().values[index].propertyId : game.getCurPCard().values[index].propertyId))!
        return ((isAi ? game.getCurAICard().values[index].value : game.getCurPCard().values[index].value) + property.getStylizedUnit())
    }
}
