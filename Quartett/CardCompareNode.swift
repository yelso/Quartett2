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
    
    var img1: SKSpriteNode?
    var img2: SKSpriteNode?
    var titleLabel: SKLabelNode?
    
    var propertyGroupNodes = [GroupActionNode]()
    var propertyNames = [SKLabelNode]()
    var propertyValuesP = [SKLabelNode]()
    var propertyValuesAi = [SKLabelNode]()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
//        img1 = SKSpriteNode(texture: SKTexture(imageNamed: "bikes1"))
//        img1?.position = CGPoint(x: 0, y: 0)
//        self.addChild(img1!)
        img1 = SKSpriteNode(texture: SKTexture(imageNamed: "tuning8"))
        img2 = SKSpriteNode(texture: SKTexture(imageNamed: "tuning7"))
        img1!.position = CGPoint(x: -80, y: 250)
        img2!.position = CGPoint(x: 80, y: 180)
        img1!.setScale(0.6)
        img2!.setScale(0.6)
        
        self.color = UIColor(red:0.02, green:0.02, blue: 0.08, alpha: 1.0)
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
    func updateDetail(forWinner winner: Card, loser: Card, game: Game) {
        
        // TODO
        //if the human player wins the round (pic and values are left side)(winnerpic is above loser pic) else ki wins round
       // if game.getCurPCard().name == winner.name {
            

            titleLabel?.text = winner.name + " " + loser.name
            //cardToCompare.images = [winner.images, loser.images]
            img1?.texture = SKTexture(imageNamed: game.getCSPCardImageNameWithoudSuffix(atIndex: 0))
            img2?.texture = SKTexture(imageNamed: game.getCSAICardImageNameWithoudSuffix(atIndex: 0))
        
            self.addChild(img2!)
        self.addChild(img1!)
            var propertyNameAndValuesOfTwoCards = (name: "NAME", valueP: "VALUEP", valueAi: "VALUEAI")
            for index in 0..<propertyNames.count {
                propertyNameAndValuesOfTwoCards = getPropertyNameAndValuesOfTwoCards(forIndex: index, game, playerCard: winner, aiCard: loser)
                
                propertyNames[index].text = propertyNameAndValuesOfTwoCards.name
                propertyValuesP[index].text = propertyNameAndValuesOfTwoCards.valueP
                propertyValuesAi[index].text = propertyNameAndValuesOfTwoCards.valueAi
                
                
            }
            
            
        /*}else{
            
        } */
        
        //for i
//        loser.values[i].propertyId
//
        
        //game parameter
        
    }
    
    func setVisible(to visible: Bool) {
        if visible {
            isHidden = false
        } else {
            isHidden = true
        }
    }
    
}
