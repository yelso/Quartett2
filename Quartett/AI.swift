//
//  AI.swift
//  Quartett
//
//  Created by Puja Dialehabady on 29.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

class AI {
    
    var cards = [Card]()
    var currentCard: Card?
    var difficulty = 1
    
    func nextCard() -> Bool {
        if cards.count > 0 {
            currentCard = cards.popLast()
            return true
        } else {
            return false
        }
    }
    
    func selectProperty(cardOpponent: Card, game: Game) -> Int {
        if arc4random_uniform(100) < (19 + difficulty * 30) { // easy 20%, medium 50%, hard 80% chance
            for index in 0..<currentCard!.values.count {
                let propertyCompare = Int(game.cardSet!.getProperty(withId: currentCard!.values[index].propertyId)!.compare!)
                let myVal = Int(currentCard!.values[index].value)!
                let valP = Int(cardOpponent.values[index].value)!
                
                if propertyCompare == 0 && myVal < valP {
                    return index
                } else if propertyCompare == 1 && myVal > valP {
                    return index
                }
            }
        }
        return Int(arc4random_uniform(UInt32(currentCard!.values.count)))
    }
}
