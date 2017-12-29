//
//  Propertie.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

struct Propertie : Codable {
    
    private let text: String?
    private let compare: String?
    private let id: String?
    private let unit: String?
    private let precision: String?
    
    init(withText text: String, compare: String, id: String, unit: String, precision: String) {
        self.text = text
        self.compare = compare
        self.id = id
        self.unit = unit
        self.precision = precision
    }
}
