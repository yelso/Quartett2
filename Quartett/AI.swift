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
    var difficulty = 0
    var selectedIndex = 0
    
    func nextCard() -> Bool {
        if cards.count > 0 {
            currentCard = cards.popLast()
            return true
        } else {
            return false
        }
    }
    
    func selectProperty(cardOpponent: Card, game: Game) {
        if arc4random_uniform(100) < (19 + game.settings!.difficulty * 30) { // easy 20%, medium 50%, hard 80% chance
            for index in 0..<currentCard!.values.count {
                let propertyCompare = Int(game.cardSet!.getProperty(withId: currentCard!.values[index].propertyId)!.compare!)
                let val = currentCard!.values[index]
                let myVal = Float(val.value)!
                let valP = Float(cardOpponent.values[index].value)!
                if (propertyCompare == -1 && myVal < valP) || (propertyCompare == 1 && myVal > valP) {
                    selectedIndex = index
                    break
                }
            }
        }
        selectedIndex = Int(arc4random_uniform(UInt32(currentCard!.values.count)))
    }
}
