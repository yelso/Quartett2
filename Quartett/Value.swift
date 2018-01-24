//
//  Value.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

struct Value: Codable {
    
    let value: String
    let propertyId: String
    
    init (value: String, propertyId: String) {
        self.value = value
        self.propertyId = propertyId
    }
}
