//
//  CardSet.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

class CardSet : Codable {
    let name: String
    var cards: [Card]?
    private let description: Description?
    let properties: [Property]
    
    init(withName name: String, cards: [Card], description: Description?, properties: [Property]) {
        self.name = name
        self.cards = cards
        self.properties = properties
        self.description = description
    }
    
    func getProperty(withId id: String) -> Property? {
        for property in properties {
            if property.id == id {
                return property
            }
        }
        return nil
    }
    
    func getName() -> String {
        return name
    }
}
