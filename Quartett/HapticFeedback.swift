//
//  HapticFeedback.swift
//  Quartett
//
//  Created by Puja Dialehabady on 06.02.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import UIKit

class HapticFeedback {
    
    static let impact = UIImpactFeedbackGenerator(style: .light)
    static let selection = UISelectionFeedbackGenerator()
    static let feedback = UINotificationFeedbackGenerator()
    
    static func success() {
        feedback.notificationOccurred(.success)
    }
    
    static func error() {
        feedback.notificationOccurred(.error)
    }
    
    static func warning() {
        feedback.notificationOccurred(.warning)
    }
    
    static func defaultFeedback() {
        selection.selectionChanged()
    }
    
    static func lightFeedback() {
        impact.impactOccurred()
    }
}
