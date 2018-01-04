//
//  CardCompareNode.swift
//  Quartett
//
//  Created by Puja Dialehabady on 02.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class CardCompareNode: SKSpriteNode {
    
    var img1: SKSpriteNode?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        img1 = SKSpriteNode(texture: SKTexture(imageNamed: "bikes1"))
        img1?.position = CGPoint(x: 0, y: 0) // TODO
        self.addChild(img1!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateDetail(forWinner winner: Card, loser: Card) {
        img1 = SKSpriteNode(texture: SKTexture(imageNamed: "tuning8"))
        // TODO
    
    }
    
    func setVisible(to visible: Bool) {
        if visible {
            isHidden = false
        } else {
            isHidden = true
        }
    }
    
}
