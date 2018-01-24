//
//  Image.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation

struct Image : Codable {
    
    var id: String
    var filename: String
    
    init(id: String, filename: String) {
        self.id = id
        self.filename = filename
    }
}
