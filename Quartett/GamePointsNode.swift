//
//  GamePointsNode.swift
//  Quartett
//
//  Created by Puja Dialehabady on 03.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class GamePointsNode: SKSpriteNode {
    
    var playerCards = 0
    var aiCards = 0
    var drawCards = 0
    var points: SKLabelNode?
    
    init(color: UIColor, size: CGSize, position: CGPoint, game: Game) {
        super.init(texture: nil, color: .clear, size: size)
        self.position = position
        //let background = SKSpriteNode(color: Color.cardMain, size: CGSize(width: self.size.width, height: size.height/2))
        //background.anchorPoint = CGPoint(x: 0.5, y: 0)
        //background.position = CGPoint(x:0, y: self.size.height/2 * -1)
        
        let titleBar = SKSpriteNode(texture: SKTexture(imageNamed: "titleBar"))
        titleBar.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        titleBar.position = CGPoint(x:0, y: 0)
        titleBar.size = CGSize(width: size.width, height: size.height/2)
       //self.addChild(background)
        //self.addChild(titleBar)
        
        let background = ActionNode(texture: SKTexture(imageNamed: "pointsBackground"))
        //background.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        points = SKLabelNode(text: "\(game.player.cards.count) - \(game.drawPile.count) - \(game.ai.cards.count)")
        points!.fontName = Font.cardTitle
        points!.fontColor = .white
        points!.fontSize = 22
        points!.horizontalAlignmentMode = .center
        points!.verticalAlignmentMode = .center
        background.addChild(points!)
        self.addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(_ game: Game) {
       points?.text = "\(game.player.cards.count) - \(game.drawPile.count) - \(game.ai.cards.count)"
    }
}
