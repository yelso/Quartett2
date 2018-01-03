//
//  Game.swift
//  Quartett
//
//  Created by Puja Dialehabady on 02.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import GameplayKit

class Game {
    
    let settings : GameSettings?
    var player = Player()
    var ai = AI()
    var cardSet: CardSet?
    init(withSettings settings: GameSettings) {
        self.settings = settings
        loadCards()
    }
    
    func loadCards() {
        guard let cardSet = CardSets.decode(resource: (CardSets(rawValue: settings!.cardSetName))!) else {
            print ("ERROR LOADING CARDSET \(settings!.cardSetName)")
            return
        }
        self.cardSet = cardSet
        
        let cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cardSet.cards) as! [Card]
        for index in 0..<cards.count {
            if (index+1)%2 == 0 {
                player.cards.append(cards[index] )
            } else {
                ai.cards.append(cards[index] )
            }
        }
        selectNextCard()
    }
    
    func selectNextCard() {
        if player.nextCard() {
            if !ai.nextCard() {
                // TODO: AI LOSE
            }
        } else {
            // TODO: PLAYER LOSE
        }
        
    }
    
}
