//
//  Constants.swift
//  Quartett
//
//  Created by Puja Dialehabady on 03.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import UIKit

struct Images {
    static let pointsBackground = ""
}

struct Color {
    
    static let cardMain = UIColor(red:1.00, green:0.93, blue:0.62, alpha:1.0)
    static let cardTitle = UIColor.white
    static let cardText = UIColor.white
    static let pointsText = UIColor.black
    
    static let blue6 = UIColor(red:0.01, green:0.78, blue:0.9, alpha:1.0)
    static let blue4 = UIColor(red:0.01, green:0.75, blue:0.9, alpha:1.0)
    static let blue5 = UIColor(red:0.01, green:0.52, blue:0.9, alpha:1.0)
    
    static let blue1 = UIColor(red:0.01, green:0.78, blue:0.9, alpha:1.0)
    static let blue2 = UIColor(red:0.01, green:0.58, blue:0.9, alpha:1.0)
    static let blue3 = UIColor(red:0.01, green:0.38, blue:0.9, alpha:1.0)
    
    
    //UIColor(red:0.01, green:0.01, blue:0.09, alpha:1.0)//UIColor(red:0.07, green:0.07, blue:0.12, alpha:1.0) //UIColor(red:0.13, green:0.13, blue:0.20, alpha:1.0)//UIColor.white//UIColor(red:0.88, green:0.95, blue:0.97, alpha:1.0)
    static let darkOrange = UIColor(red:1.00, green:0.31, blue:0.00, alpha:1.0)
    static let middleOrange = UIColor(red:1.00, green:0.44, blue:0.00, alpha:1.0)
    static let lightOrange = UIColor(red:1.00, green:0.64, blue:0.00, alpha:1.0)
    
    static let green1 = UIColor(red:0.01, green:0.84, blue:0.05, alpha:1.0)
    static let green2 = UIColor(red:0.01, green:0.54, blue:0.05, alpha:1.0)
    
    static let background = UIColor(red:0.02, green:0.02, blue:0.08, alpha:1.0)
    
}

struct Scale {
    static var widthMultiplier: Float {
        if UIScreen.main.bounds.height != 812 { // all but iPhone X
            return 0.65
        } else {
            return 0.6
        }
    }
    
    static var heightMultiplier: Float {
        if UIScreen.main.bounds.height != 812 { // all but iPhone X
            return 0.85
        } else {
            return 0.8
        }
    }
}

struct Font {
    static let cardTitle = "Helvetica Neue Medium"
    static let cardText = "Helvetica Neue Light"
    static let buttonFont = "Helvetica Neue Thin"
    static let solutionText = "Georgia"
    static let solutionText2 = "Helvetica Neue Light Italic"
}
