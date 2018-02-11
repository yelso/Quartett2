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
    var height: CGFloat = 0
    var amount = 0
    var scaleFactor: CGFloat = 0.03
    var scale: CGFloat = 1.0
    
    init(game: Game, color: UIColor, size: CGSize, position: CGPoint) {
        super.init(texture: nil, color: color, size: size)
        self.position = position
        setUpChildren(for: game)
        if UIScreen.main.bounds.height != 812 { // all but iPhone X
            scale = 1.05
            scaleFactor = 0.05
            self.setScale(scale)
        }
    }
    
    func update(_ game: Game) {
        let newCard = game.getCurPCard()
        titleLabel?.text = newCard.name
        img?.texture = SKTexture(image: FileUtils.loadImage(setName: game.cardSet!.name.lowercased(), cardId: game.getCurPCard().id, name: game.getCSPCardImageNameWithoudSuffix(atIndex: 0)))
        var propertyNameAndValue = (name: "NAME", value: "VALUE")
        for index in 0..<amount {
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
    
    func setUpChildren(for game: Game) {
        self.amount = game.getCurPCard().values.count
        self.height = CGFloat(((amount + 1) * 42) + 195) // property amounts + cell top + imageHeight/2
        self.size = CGSize(width: size.width, height: height)
        let cell = SKSpriteNode(texture: SKTexture(imageNamed: "cellTop"))
        cell.position = CGPoint(x:0, y: height/2 - 20) // 20 is half of cells height
        let label = SKLabelNode(text: game.getCurPCard().name)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = 17
        label.fontColor = Color.cardTitle
        label.fontName = Font.cardTitle
        titleLabel = label
        
        img = SKSpriteNode(texture: SKTexture(image: FileUtils.loadImage(setName: game.cardSet!.name.lowercased(), cardId: game.getCurPCard().id, name: game.getCSPCardImageNameWithoudSuffix(atIndex: 0))))
        img!.scale(to: CGSize(width: 300, height: 195))
        img!.position = CGPoint(x: 0, y: height/2 - 139.5) // 195/2 +40 (cell height) + 2 spacer
        
        cell.addChild(label)
        self.addChild(img!)
        self.addChild(cell)
        let pos: CGFloat = img!.position.y - img!.size.height/2 - 22 // 20 cell height + 2 spacer
        
        for index in 1...amount {
            let cell = setUpCell(withImageNamed: "cell\(amount - index)", color: UIColor.black, blendFactor: 0, position: CGPoint(x: 0, y: (pos + CGFloat(-42 * (index-1)))), anchorPoint: CGPoint(x: 0.5, y: 0.5)) //
            let labels = setUpLabels(for: cell, game: game, index: index-1)
            cell.addChild(labels.name)
            cell.addChild(labels.value)
            propertyGroupNodes.append(cell)
            propertyNames.append(labels.name)
            propertyValues.append(labels.value)
            self.addChild(cell)
        }
        
        
        if amount > 6 {
            self.setScale(scale - (CGFloat(amount-6) * scaleFactor))
        }
        
        propertyGroupNodes[0].setUpGroup(propertyGroupNodes)
        
        for index in 0..<amount {
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
                    member.isHighlighted = false
                }
            }
        }
    }
    // creates a cell with an image
    func setUpCell(withImageNamed image: String, color: UIColor, blendFactor: CGFloat, position: CGPoint, anchorPoint: CGPoint) -> GroupActionNode {
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
        nameLabel.verticalAlignmentMode = .center
        nameLabel.fontColor = Color.cardText
        nameLabel.fontName = Font.cardText
        nameLabel.fontSize = 15
        let valueLabel = SKLabelNode(text: propertyNameAndValue.value)
        valueLabel.position = CGPoint(x: (cell.size.width/2) * 0.95, y: 0)
        valueLabel.horizontalAlignmentMode = .right
        valueLabel.verticalAlignmentMode = .center
        valueLabel.fontColor = Color.cardText
        valueLabel.fontName = Font.cardText
        valueLabel.fontSize = 15
        
        return (nameLabel, valueLabel)
    }
    
    func getPropertyNameAndValue(forIndex index: Int, _ game: Game) -> (name: String, value: String) {
        let property = game.cardSet!.getProperty(withId: game.getCurPCard().values[index].propertyId)!
        return (property.text!, game.getCurPCard().values[index].value + property.getStylizedUnit())
    }
    
    func setInteractionEnabledTo(_ value: Bool) {
        for node in propertyGroupNodes {
            node.isUserInteractionEnabled = value
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
