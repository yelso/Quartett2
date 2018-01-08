//
//  CardNode.swift
//  Quartett
//
//  Created by Puja Dialehabady on 03.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class CardNode: SKSpriteNode {
    
    var delegate: CardDelegate?
    
    var img: SKSpriteNode?
    var titleLabel: SKLabelNode?
    var propertyGroupNodes = [GroupActionNode]()
    var propertyNames = [SKLabelNode]()
    var propertyValues = [SKLabelNode]()
    
    init(game: Game, color: UIColor, size: CGSize, position: CGPoint) {
        super.init(texture: nil, color: color, size: size)
        self.position = position
        setUpChildren(for: game)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpChildren(for game: Game) {
        // create top cell with title and image
        let cell = SKSpriteNode(texture: SKTexture(imageNamed: "cellTop"))
        cell.position = CGPoint(x:0, y: 226)
        let label = SKLabelNode(text: game.getCurPCard().name)
        label.position = CGPoint(x: (cell.size.width/2) * 0.94 * -1 , y: 0)
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.fontSize = 18
        label.fontColor = Color.cardTitle
        label.fontName = Font.cardTitle
        titleLabel = label
        
        img = SKSpriteNode(texture: SKTexture(imageNamed: game.getCSPCardImageNameWithoudSuffix(atIndex: 0)))
        img!.position = CGPoint(x: 0, y: 106.5)
        img!.scale(to: CGSize(width: 300, height: 195))
        
        cell.addChild(label)
        self.addChild(img!)
        self.addChild(cell)
        
        // fill each cell with property values and names
        for index in 1...game.getCurPCard().values.count {
            let cell = setUpCell(withImageNamed: "cell\(game.getCurPCard().values.count - index)", color: UIColor.black, blendFactor: 0, position: CGPoint(x:0, y: (-20 + (-42 * (index-1)))), anchorPoint: CGPoint(x: 0.5, y: 0.35)) //
            let labels = setUpLabels(for: cell, game: game, index: index-1)
            cell.addChild(labels.name)
            cell.addChild(labels.value)
            propertyGroupNodes.append(cell)
            propertyNames.append(labels.name)
            propertyValues.append(labels.value)
            self.addChild(cell)
        }
        
        propertyGroupNodes[0].setUpGroup(propertyGroupNodes)
        
        for index in 0..<propertyGroupNodes.count {
            let propertyNode = propertyGroupNodes[index]
            propertyNode.isHighlightButton = true
            propertyNode.customAnimationEnabled = true
            propertyNode.action = {
                self.delegate?.didSelectProperty(atIndex: index)
            }
            propertyNode.onReset = {
                propertyNode.setScale(1.0)
                propertyNode.color = UIColor.black
                propertyNode.colorBlendFactor = 0.0
            }
            propertyNode.onTouch = {
                propertyNode.run(propertyNode.defaultOnTouchAnimation())
            }
            propertyNode.onTouchEnd = {
                propertyNode.run(propertyNode.defaultOnTouchEndAnimation())
            }
            propertyNode.onTouchEndInside = {
                let scaleAction = SKAction.scale(to: 1.00, duration: 0.15)
                let colorizeAction = SKAction.colorize(with: UIColor.orange, colorBlendFactor: 1, duration: 0.15)
                propertyNode.run(SKAction.group([scaleAction, colorizeAction]))
                
            }
            propertyNode.onTouchEndInsideGroup = {
                for member in propertyNode.group {
                    member.colorBlendFactor = 0
                    member.color = UIColor.black
                }
            }
        }
    }
    // creates a cell with an image
    func setUpCell(withImageNamed image: String, color: UIColor, blendFactor: CGFloat, position: CGPoint, anchorPoint: CGPoint) -> GroupActionNode {
        print("using image: \(image)")
        let cell = GroupActionNode(texture: SKTexture(imageNamed: image))
        cell.color = color
        cell.colorBlendFactor = blendFactor
        cell.anchorPoint = anchorPoint
        cell.position = position
        return cell
    }
    
    func setUpLabels(for cell: GroupActionNode, game: Game, index: Int) -> (name: SKLabelNode, value: SKLabelNode) {
        let propertyNameAndValue = getPropertyNameAndValue(forIndex: index, game)
        let nameLabel = SKLabelNode(text: propertyNameAndValue.name)
        nameLabel.position = CGPoint(x: (cell.size.width/2) * 0.95 * -1 , y: 0)
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.fontColor = Color.cardText
        nameLabel.fontName = Font.cardText
        nameLabel.fontSize = 15
        let valueLabel = SKLabelNode(text: propertyNameAndValue.value)
        valueLabel.position = CGPoint(x: (cell.size.width/2) * 0.95, y: 0)
        valueLabel.horizontalAlignmentMode = .right
        valueLabel.fontColor = Color.cardText
        valueLabel.fontName = Font.cardText
        valueLabel.fontSize = 15
        
        return (nameLabel, valueLabel)
    }
    
    func update(_ game: Game) {
        let newCard = game.getCurPCard()
        titleLabel?.text = newCard.name
        img?.texture = SKTexture(imageNamed: game.getCSPCardImageNameWithoudSuffix(atIndex: 0))
        var propertyNameAndValue = (name: "NAME", value: "VALUE")
        for index in 0..<propertyNames.count {
            propertyNameAndValue = getPropertyNameAndValue(forIndex: index, game)
            propertyNames[index].text = propertyNameAndValue.name
            propertyValues[index].text = propertyNameAndValue.value
        }
        for index in 0..<propertyGroupNodes.count {
            if propertyGroupNodes[index].isHighlighted {
                propertyGroupNodes[index].handleReset()
            }
        }
    }
    
    func getPropertyNameAndValue(forIndex index: Int, _ game: Game) -> (name: String, value: String) {
        let property = game.cardSet!.getProperty(withId: game.getCurPCard().values[index].propertyId)!
        return (property.text!, game.getCurPCard().values[index].value + property.getStylizedUnit())
    }
}
