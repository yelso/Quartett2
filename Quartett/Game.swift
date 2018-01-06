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
    
    func selectNextCard() -> Bool {
        if player.nextCard() {
            if !ai.nextCard() {
                // TODO: AI LOSE
                return false
            }
        } else {
            // TODO: PLAYER LOSE
            return false
        }
        
        return true
    }
    
    func calculateResult(forSelectedIndex index: Int) {
        // TODO:
    }
    
    func nextRound() -> Bool{
        // TODO
        return selectNextCard()
    }
    
    func getCurPCard() -> Card {
        return player.currentCard!
    }
    
    func getCurAICard() -> Card {
        return ai.currentCard!
    }
    
    // return CardSet + Player Card Image name without suffix at index
    func getCSPCardImageNameWithoudSuffix(atIndex index: Int) -> String {
        return cardSet!.name.lowercased() + player.currentCard!.getImageNameWithoutSuffix(atIndex: index)
    }
    
    func getCSAICardImageNameWithoudSuffix(atIndex index: Int) -> String {
        return cardSet!.name.lowercased() + ai.currentCard!.getImageNameWithoutSuffix(atIndex: index)
    }
}
