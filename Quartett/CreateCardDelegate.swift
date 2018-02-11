//
//  CreateCardDelegate.swift
//  Quartett
//
//  Created by Puja Dialehabady on 05.02.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import UIKit

protocol CreateCardDelegate {
    func prepareForUpload(_ cards: [Int : (cardName: String, image: UIImage?, values: [Int : String])], _ attrAndUnits: [Int : (name: String, unit: String, comparison: String)])
    
    func takeOrSelectImage()
}
