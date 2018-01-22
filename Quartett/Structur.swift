//
//  Structur.swift
//  Quartett
//
//  Created by Puja Dialehabady on 20.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation

struct Deck: Codable {
    var id: Int?
    var name: String?
}

struct Card2: Codable {
    var id: Int?
    //var deck: Int?
    var name: String?
    //var order: Int?
    var attributes: [Attribut]?
    var image: String?
    
    mutating func setAttributes(_ attributes: [Attribut]) {
        self.attributes = attributes
    }
}

struct Attribut: Codable {
    var id: Int?
    var card: Int?
    var name: String?
    var value: String?
    var unit: String?
    var what_wins: String?
    var image: String?
}

struct Image2: Codable {
    var id: Int?
    var card: Int?
    var order: Int?
    var description: String?
    var image: String?
}
