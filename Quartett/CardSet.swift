//
//  CardSet.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

class CardSet : Codable {
    private let name: String
    private let cards: [Card]
    private let description: Description?
    private let properties: [Propertie]
    
    init(withName name: String, cards: [Card], description: Description?, properties: [Propertie]) {
        self.name = name
        self.cards = cards
        self.properties = properties
        self.description = description
    }
    
    static func decode(resource name: String) -> CardSet? {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let decoder = JSONDecoder()
            var cardSet: CardSet?
            do {
                try cardSet = decoder.decode(CardSet.self, from: jsonData!)
            } catch let error {
                print(error)
            }
        
            return cardSet!
        }
        return nil
    }
    
    func getName() -> String {
        return name
    }
}
