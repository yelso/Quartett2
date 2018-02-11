//
//  Extensions.swift
//  Quartett
//
//  Created by Puja Dialehabady on 30.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

extension SKSpriteNode {
    
    func shake(delayed delay: TimeInterval) {
        self.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.moveBy(x: 5, y: 0, duration: 0.04), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 10, y: 0, duration: 0.08), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 5, y: 0, duration: 0.04)]))
    }
    
    func shake() {
        self.run(SKAction.sequence([SKAction.moveBy(x: 5, y: 0, duration: 0.04), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 10, y: 0, duration: 0.08), SKAction.moveBy(x: -10, y: 0, duration: 0.08), SKAction.moveBy(x: 5, y: 0, duration: 0.04)]))
    }
}
