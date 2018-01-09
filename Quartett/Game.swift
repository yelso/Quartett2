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
    var rounds = Rounds()
    var gameResult: Result?
    var isPlayersTurn = true
    
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
    //DRAW???
    func selectNextCard() -> Bool {
        if player.nextCard() {
            if !ai.nextCard() {
                gameResult = Result.playerWin
                return false
            }
        } else {
            gameResult = Result.playerLose
            return false
        }
        if !isPlayersTurn {
            ai.selectProperty(cardOpponent: player.currentCard!, game: self)
        }
        return true
    }
    
    func calculateResult(forSelectedIndex index: Int) -> Result {
        let propertyCompare = Int(cardSet!.getProperty(withId: getCurPCard().values[index].propertyId)!.compare!)
        let pVal = Float(getCurPCard().values[index].value)!
        let aiVal = Float(getCurAICard().values[index].value)!
        
        var result = Result.draw
        if propertyCompare == 0 {
            if pVal < aiVal {
                result = Result.playerWin
            } else if aiVal < pVal {
                result = Result.playerLose
            } else {
                result = Result.draw
            }
        } else if propertyCompare == 1 {
            if pVal > aiVal {
                result = Result.playerWin
            } else if aiVal > pVal {
                result = Result.playerLose
            } else {
                result = Result.draw
            }
        }
        if result == Result.playerWin {
            player.cards.insert(getCurAICard(), at: 0)
            isPlayersTurn = true
        } else if result == Result.playerLose {
            ai.cards.insert(getCurPCard(), at: 0)
            isPlayersTurn = false
        } else {
            isPlayersTurn = !isPlayersTurn
        }
        rounds.results.append(result)
        return result
    }
    
    func nextRound() -> Bool {
        if rounds.curRound < settings!.maxRounds || settings?.maxRounds == -1 {
            rounds.curRound += 1
            return selectNextCard()
        } else {
            if player.cards.count > ai.cards.count {
                gameResult = Result.playerWin
            } else if ai.cards.count > player.cards.count {
                gameResult = Result.playerLose
            } else {
                gameResult = Result.draw
            }
            return false
        }
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
    
    func getAiSelection() -> Int {
        return ai.selectedIndex
    }
}
