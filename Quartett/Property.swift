//
//  Propertie.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

struct Property : Codable {
    
    let text: String?
    let compare: String?
    let id: String?
    var unit: String?
    private let precision: String?
    
    init(withText text: String, compare: String, id: String, unit: String, precision: String) {
        self.text = text
        self.compare = compare
        self.id = id
        self.unit = unit
        self.precision = precision
    }
    
    func getStylizedUnit() -> String {
        guard unit != nil else { return ""}
        if (unit!.starts(with: "1")) {
            return "\(self.unit!.dropFirst())"
        } else {
            return " \(unit!)"
        }
    }
}
