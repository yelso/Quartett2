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
    
    static func selectProperty(card fromCard: Card) -> Property? {
        // TODO: select propertie based on the difficulty
        return nil
    }
}
