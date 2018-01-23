//
//  CardSets.swift
//  Quartett
//
//  Created by Puja Dialehabady on 27.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

enum CardSets: String {
    case tuning = "tuning"
    case bikes = "bikes"
    
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
}
