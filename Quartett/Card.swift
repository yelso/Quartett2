//
//  Card.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

struct Card: Codable {
    
    let images : [Image]
    let values : [Value]
    let id : String
    let name : String
    private let description: Description?
    
    init(withId id: String, name: String, description: Description?, values: [Value], images: [Image]) {
        self.id = id
        self.name = name
        self.values = values
        self.images = images
        self.description = description
    }
    
    func getImageNameWithoutSuffix(atIndex index: Int) -> String {
        return String(images[index].filename.dropLast(4))
    }
}
