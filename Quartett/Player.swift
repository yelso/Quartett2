//
//  Player.swift
//  Quartett
//
//  Created by Puja Dialehabady on 29.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
class Player {
    
    var cards = [Card]()
    var currentCard: Card?
    
    func nextCard() -> Bool {
        if cards.count > 0 {
            currentCard = cards.popLast()
            return true
        } else {
            return false
        }
    }
    
}
