//
//  CardSetOverviewDetailScene.swift
//  Quartett
//
//  Created by Linda Schrödl on 29.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class CardSetOverviewDetailScene: SKScene {
    var img: SKSpriteNode?
    var imgName = "bikes2"
    override func didMove(to view: SKView) {
        // TODO
        if let image = self.childNode(withName: "img") as? SKSpriteNode {
            img = image
            img?.texture = SKTexture(imageNamed: imgName)
        }
    }
}

