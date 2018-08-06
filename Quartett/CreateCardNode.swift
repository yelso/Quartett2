//
//  CardNode2.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit
import Photos
import os.log

class CreateCardNode: SKSpriteNode, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var delegate: CreateCardDelegate?
    var img: ActionNode!
    var cardTitleLabel: SKLabelNode?
    var topCell : ActionNode!
    var cells = [ActionNode]()
    var cardNode : SKSpriteNode!
    var height: CGFloat = 0
    var amount = 4
    var scaleFactor: CGFloat = 0.055
    var scale: CGFloat = 1.0
    var attributesAndUnits = [Int : (name: String, unit: String, comparison: String)]()
    var cardLabels = [(name: SKLabelNode, value: SKLabelNode)]()
    var cards = [Int : (cardName: String, image: UIImage?, values: [Int : String])]()
    var curIndex = 0
    var view: SKView!
    var indexLabel: SKLabelNode!
    var nextCardButton: ActionNode!
    var prevCardButton: ActionNode!
    var closeButton: ActionNode!
    var uploadButton: ActionNode!
    var addCellButton: ActionNode!
    var title: SKLabelNode!
    var imageLabel: SKLabelNode!
    var imageText: SKLabelNode!
    var comparisonNodes = [Int: SKLabelNode]()
    
    init(view: SKView, color: UIColor, size: CGSize, position: CGPoint, delegate: CreateCardDelegate) {
        self.view = view
        super.init(texture: nil, color: color, size: size)
        self.position = position
        self.delegate = delegate
        if UIScreen.main.bounds.height != 812 { // all but iPhone X
            //scale = 1.05
            //scaleFactor = 0.055
            //self.setScale(scale)
        }
        cardNode = SKSpriteNode(color: .clear, size: size)
        self.addChild(cardNode)
        
        title = SKLabelNode(text: "Karte erstellen")
        title.fontName = Font.buttonFont
        title.position = CGPoint(x: -160  * Scale.sceneScaleX, y: 260)
        print(UIScreen.main.bounds.width/414)
        title.horizontalAlignmentMode = .left
        self.addChild(title)
        
        setUpCardUI()
        newCard()
        
        addCellButton = ActionNode(color: .clear, size: CGSize(width: 30, height: 30))
        addCellButton.position = CGPoint(x: 0, y: cells.last!.position.y - cells.last!.size.height/2 - 15)
        let addCellLabel = SKLabelNode(text: "+")
        addCellLabel.verticalAlignmentMode = .center
        addCellLabel.fontName = Font.cardTitle
        addCellLabel.fontSize = 24
        addCellLabel.color = .white
        
        addCellButton.action = {
            self.addNewCell()
        }
        
        addCellButton.addChild(addCellLabel)
        
        self.addChild(addCellButton)
        
        nextCardButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        prevCardButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        closeButton = ActionNode(texture: SKTexture(imageNamed: "closeButton"))
        uploadButton = ActionNode(texture: SKTexture(imageNamed: "uploadButton"))

        nextCardButton.customFeedbackEnabled = true
        nextCardButton.position = CGPoint(x: 100, y: /*cells.last!.position.y */ -290 /*cells.last!.size.height - 25*/)
        prevCardButton.position = CGPoint(x: -100, y: -290) //cells.last!.position.y - cells.last!.size.height - 25)
        closeButton.position = CGPoint(x: -closeButton.size.width, y: -325) //cells.last!.position.y - cells.last!.size.height - 70)
        uploadButton.position = CGPoint(x: closeButton.size.width, y: -325) //cells.last!.position.y - cells.last!.size.height - 70)
        indexLabel = SKLabelNode(text: "\(curIndex+1)/\(cards.count)")
        indexLabel.position = CGPoint(x: 0, y: -290) //cells.last!.position.y - cells.last!.size.height - 25)
        indexLabel.horizontalAlignmentMode = .center
        indexLabel.verticalAlignmentMode = .center
        indexLabel.fontSize = 20
        indexLabel.fontColor = Color.cardTitle
        indexLabel.fontName = Font.buttonFont
        
        uploadButton.action = {
            self.upload()
        }
        
        nextCardButton.action = {
            self.nextCard()
        }
        
        prevCardButton.action = {
            self.prevCard()
        }
        
        closeButton.action = {
            if let scene = SKScene(fileNamed: "StoreScene") as? StoreScene {
                //nameTextField.removeFromSuperview()
                scene.scaleMode = .aspectFill
                //scene.origin = self.origin
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
        
        //prevCardButton.disable()
        self.addChild(closeButton)
        self.addChild(nextCardButton)
        self.addChild(prevCardButton)
        self.addChild(uploadButton)
        self.addChild(indexLabel)
    }
    
    func setUpCardUI() {
        self.height = CGFloat(((amount + 1) * 42) + 195)
        let cell = ActionNode(texture: SKTexture(imageNamed: "cellTop"))
        cell.position = CGPoint(x:0, y: height/2 - 20) // 20 is half of cells height
        let label = SKLabelNode(text: "Name")
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = 17
        label.fontColor = Color.cardTitle
        label.fontName = Font.cardTitle
        //label.isUserInteractionEnabled = true
        cell.addChild(label)
        let alertController = UIAlertController(title: "Name eingeben", message: "Gib den Namen der Karte ein.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (_) in }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if (alertController.textFields?[0].text?.isEmpty)!{
                HapticFeedback.error()
                cell.shake()
            } else {
                if !self.cards.isEmpty && self.cards.keys.contains(self.curIndex) {
                    self.cards[self.curIndex]!.cardName = (alertController.textFields?[0].text)!
                    self.cardTitleLabel?.text = (alertController.textFields?[0].text)!
                }
                alertController.textFields?[0].text = ""
            }
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        cell.action = {
            if !self.cards.isEmpty && self.cards.keys.contains(self.curIndex) && self.cards[self.curIndex]?.cardName != "" {
                alertController.textFields?[0].text = self.cards[self.curIndex]?.cardName
            } else {
                alertController.textFields?[0].text = ""
            }
            DispatchQueue.main.async {
                self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
        
        let deleteCardNode = ActionNode(color: .clear, size: CGSize(width: 35, height: 35))
        deleteCardNode.position = CGPoint(x: -cell.size.width * 0.45, y: 0)
        deleteCardNode.scale = 0.85
        
        deleteCardNode.action = {
            self.removeCard(at: self.curIndex)
        }
        
        let deleteLabel = SKLabelNode(text: "+")
        deleteLabel.zRotation = CGFloat(Double.pi/4.0)
        deleteLabel.verticalAlignmentMode = .center
        deleteLabel.fontName = Font.cardTitle
        deleteLabel.fontSize = 26
        deleteLabel.color = .white
        deleteLabel.position = CGPoint(x: 0 /* -cell.size.width * 0.44*/, y: 0)
        
        deleteCardNode.addChild(deleteLabel)
        cell.addChild(deleteCardNode)
        
        cardTitleLabel = label
        
        img = ActionNode(color: Color.darkOrange, size: CGSize(width: 300, height: 195))
        //img!.scale(to: CGSize(width: 300, height: 195))
        img.position = CGPoint(x: 0, y: height/2 - 139.5)
        img.action = {
            self.delegate?.takeOrSelectImage()
        }
        
        imageLabel = SKLabelNode(text: "📷")
        imageLabel.horizontalAlignmentMode = .center
        imageLabel.verticalAlignmentMode = .center
        imageLabel.position = CGPoint(x: 0, y: 25)
        imageLabel.fontSize = 55
        imageText = SKLabelNode(text: "Bild hinzufügen")
        imageText.horizontalAlignmentMode = .center
        imageText.verticalAlignmentMode = .center
        imageText.position = CGPoint(x: 0, y: -25)
        imageText.fontSize = 17
        imageText.fontName = Font.cardTitle
        img!.addChild(imageLabel)
        img!.addChild(imageText)
        
        //cell.addChild(label)
        cardNode.addChild(img!)
        cardNode.addChild(cell)
        topCell = cell
        let pos: CGFloat = img!.position.y - img!.size.height/2 - 22 // 20 cell height + 2 spacer
        
        for index in 1...amount {
            let cell = setUpCell(withImageNamed: "cell\(amount - index)", color: UIColor.black, blendFactor: 0, position: CGPoint(x: 0, y: (pos + CGFloat(-42 * (index-1)))), anchorPoint: CGPoint(x: 0.5, y: 0.5))
            cell.zPosition = 10
            
            let labels = setUpLabels(for: cell)
            
            
            let deleteCellNode = ActionNode(color: .clear, size: CGSize(width: 35, height: 35))
            deleteCellNode.position = CGPoint(x: -cell.size.width * 0.45, y: 0)
            deleteCellNode.scale = 0.85
            let closeCellLabel = SKLabelNode(text: "+")
            closeCellLabel.zRotation = CGFloat(Double.pi/4.0)
            closeCellLabel.verticalAlignmentMode = .center
            closeCellLabel.fontName = Font.cardTitle
            closeCellLabel.fontSize = 26
            closeCellLabel.color = .white
            closeCellLabel.position = CGPoint(x: 0, y: 1)
            
            deleteCellNode.addChild(closeCellLabel)
            deleteCellNode.action = {
                self.removeCell(at: self.cells.index(of: cell)!)
            }
            
            
            let comparisonNode = SKLabelNode(text: "^")
            comparisonNode.position = CGPoint(x: cell.size.width * 0.45, y: -1)
            comparisonNode.zRotation = .pi
            comparisonNode.verticalAlignmentMode = .center
            comparisonNode.horizontalAlignmentMode = .center
            comparisonNode.fontName = Font.cardTitle
            comparisonNode.fontSize = 22
            comparisonNode.color = .white
            comparisonNodes[index-1] = comparisonNode
            //comparisonNode.position = CGPoint(x: 0, y: 1)
            
            cell.addChild(comparisonNode)
            cell.addChild(deleteCellNode)
            cell.addChild(labels.name)
            cell.addChild(labels.value)
            
            let alertController = createAlert(for: cell)
            
            cell.action = {
                DispatchQueue.main.async {
                    self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    if !self.cards.isEmpty && self.cards.keys.contains(self.curIndex) && !self.cards[self.curIndex]!.values.isEmpty && self.cards[self.curIndex]!.values.keys.contains(index-1) {
                        alertController.textFields?[1].text = self.findValueFor(index: index-1)
                    } else {
                        alertController.textFields?[1].text = ""
                    }
                }
            }
            
            cardLabels.append(labels)
            cardNode.addChild(cell)
            cells.append(cell)
        }
    }
    
    func addNewCell() {
        if amount < 8 {
            addCellButton.disable()
            amount += 1
            height = CGFloat(((amount + 1) * 42) + 195)
            
            let pos: CGFloat = (height/2 - 139.5) - img.size.height/2 - 22 // 20 cell height + 2 spacer

            let cell = setUpCell(withImageNamed: "cell0", color: UIColor.black, blendFactor: 0, position: CGPoint(x: 0, y: (pos + CGFloat(-42 * (amount-2)))), anchorPoint: CGPoint(x: 0.5, y: 0.5))
            cell.zPosition = 9
            cell.alpha = 0
            cells.append(cell)
            cardNode.addChild(cell)
            
            let labels = setUpLabels(for: cell)
        
        
            let deleteCellNode = ActionNode(color: .clear, size: CGSize(width: 35, height: 35))
            deleteCellNode.position = CGPoint(x: -cell.size.width * 0.45, y: 0)
            deleteCellNode.scale = 0.85
            let closeCellLabel = SKLabelNode(text: "+")
            closeCellLabel.zRotation = CGFloat(Double.pi/4.0)
            closeCellLabel.verticalAlignmentMode = .center
            closeCellLabel.fontName = Font.cardTitle
            closeCellLabel.fontSize = 26
            closeCellLabel.color = .white
            closeCellLabel.position = CGPoint(x: 0, y: 1)
        
            deleteCellNode.addChild(closeCellLabel)
            deleteCellNode.action = {
                self.removeCell(at: self.cells.index(of: cell)!)
            }
            
            let comparisonNode = SKLabelNode(text: "^")
            comparisonNode.position = CGPoint(x: cell.size.width * 0.45, y: -1)
            comparisonNode.zRotation = .pi
            comparisonNode.verticalAlignmentMode = .center
            comparisonNode.horizontalAlignmentMode = .center
            comparisonNode.fontName = Font.cardTitle
            comparisonNode.fontSize = 22
            comparisonNode.color = .white
            comparisonNodes[amount-1] = comparisonNode
            
            cell.addChild(comparisonNode)
            cell.addChild(deleteCellNode)
        
            
            cell.addChild(labels.name)
            cell.addChild(labels.value)
            cardLabels.append(labels)
            let alertController = createAlert(for: cell)
        
            cell.action = {
                DispatchQueue.main.async {
                    self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    if !self.cards.isEmpty && self.cards.keys.contains(self.curIndex) && !self.cards[self.curIndex]!.values.isEmpty &&  self.cards[self.curIndex]!.values.keys.contains(self.amount-1) {
                        alertController.textFields?[1].text = self.findValueFor(index: self.amount-1)
                    } else {
                        alertController.textFields?[1].text = ""
                    }
                }
            }
            
            topCell.run(SKAction.moveTo(y: height/2 - 20, duration: 0.3))
            img.run(SKAction.moveTo(y: height/2 - 139.5, duration: 0.3))
            var cardScale:CGFloat = 1
            if amount > 6 {
                cardScale = scale - (CGFloat(amount-6) * scaleFactor)
                cardNode.run(SKAction.scale(to: cardScale, duration: 0.3))
                print("scaling down to: \(cardScale)")
            }
            for index in 1..<amount {
                cells[index-1].run(SKAction.group([
                    SKAction.animate(with: [SKTexture(imageNamed: "cell\(self.amount - index)")], timePerFrame: 0.3),
                    SKAction.moveTo(y: (pos + CGFloat(-42 * (index-1))), duration: 0.3)
                    ]))
            }
            
            cell.run(SKAction.group([
                SKAction.moveBy(x: 0, y: -42, duration: 0.3),
                SKAction.fadeIn(withDuration: 0.3),
                SKAction.afterDelay(0.3, runBlock: { cell.zPosition = 10 })
                ]))
            if amount >= 8 {
                addCellButton.removeFromParent()
                addCellButton.enable()
            } else {
                addCellButton.run(SKAction.sequence([ SKAction.moveTo(y: -height/2 * cardScale - 15, duration: 0.3), SKAction.run {
                    self.addCellButton.enable()
                    }]))
            }
        }
    }
    
    func removeCell(at index: Int) {
        if amount > 4 {
            if index < cells.count {
                var newCells = [ActionNode]()
                for cellIndex in 0..<cells.count {
                    if cellIndex != index {
                        newCells.append(cells[cellIndex])
                    }
                }
                cells[index].removeFromParent()
                cells = newCells
                var newLabels = [(name: SKLabelNode, value: SKLabelNode)]()
                for labelIndex in 0..<cardLabels.count {
                    if labelIndex != index {
                        newLabels.append(cardLabels[labelIndex])
                    }
                }
                
                var newComparisonNodes = [Int: SKLabelNode]()
                var newComparisonIndex = 0
                for compareNodeIndex in 0..<comparisonNodes.count {
                    if compareNodeIndex != index {
                        newComparisonNodes[newComparisonIndex] = comparisonNodes[compareNodeIndex]
                        newComparisonIndex += 1
                    }
                }
                comparisonNodes = newComparisonNodes
                
                cardLabels = newLabels
                amount -= 1
                height = CGFloat(((amount + 1) * 42) + 195)
                let pos: CGFloat = (height/2 - 139.5) - img.size.height/2 - 22 // 20 cell height + 2 spacer
                topCell.run(SKAction.moveTo(y: height/2 - 20, duration: 0.3))
                img.run(SKAction.moveTo(y: height/2 - 139.5, duration: 0.3))
                var cardScale:CGFloat = 1
                if amount > 6 {
                    cardScale = scale - (CGFloat(amount-6) * scaleFactor)
                    cardNode.run(SKAction.scale(to: cardScale, duration: 0.3))
                }
                for index in 0..<amount {
                    cells[index].run(SKAction.group([
                        SKAction.animate(with: [SKTexture(imageNamed: "cell\(self.amount - (index+1))")], timePerFrame: 0.3),
                        SKAction.moveTo(y: (pos + CGFloat(-42 * index)), duration: 0.3)
                        ]))
                }
                if (amount+1) == 8 {
                    addCellButton.alpha = 0
                    self.addChild(addCellButton)
                    addCellButton.run(SKAction.group([ SKAction.fadeIn(withDuration: 0.3),  SKAction.sequence([ SKAction.moveTo(y: -height/2 * cardScale - 15, duration: 0.3), SKAction.run { self.addCellButton.enable() }])]))
                    
                } else {
                    addCellButton.disable()
                    addCellButton.run(SKAction.sequence([ SKAction.moveTo(y: -height/2 * cardScale - 15, duration: 0.3), SKAction.run {
                        self.addCellButton.enable()
                        }]))
                }
            
                var newAttrAndUnits = [Int : (name: String, unit: String, comparison: String)]()
                var newAttrIndex = 0
                for attrIndex in 0..<attributesAndUnits.count {
                    if attrIndex != index {
                        newAttrAndUnits[newAttrIndex] = attributesAndUnits[attrIndex]
                        newAttrIndex += 1
                    }
                }
            
                attributesAndUnits = newAttrAndUnits
            
                for cardIndex in 0..<cards.count {
                    var newVals = [Int: String]()
                    var newValIndex = 0
                    for valIndex in 0..<cards[cardIndex]!.values.count {
                        if valIndex != index {
                            newVals[newValIndex] = cards[cardIndex]!.values[valIndex]
                            newValIndex += 1
                        }
                    }
                    cards[cardIndex]?.values = newVals
                }
            
            }
        } else {
            if index < cells.count {
                HapticFeedback.error()
                cells[index].shake()
            }
        }
    }
    
    func removeCard(at index: Int) {
        if !cards.isEmpty && cards.count > 1 && cards.keys.contains(index) {
            var newCards = [Int : (cardName: String, image: UIImage?, values: [Int : String])]()
            var count = 0
            for cardIndex in 0..<cards.count {
                if index != cardIndex {
                    newCards[count] = cards[cardIndex]
                    count += 1
                }
            }
            cards = newCards
            if (curIndex-1) >= 0 {
                curIndex -= 1
            }
            updateCard()
            updateIndexLabel()
        } else {
            HapticFeedback.error()
            cardNode.shake()
        }
    }
    
    func createAlert(for cell: ActionNode) -> UIAlertController {
        let alertController = UIAlertController(title: "Werte eingeben", message: "Gib den Namen, den Wert und die Einheit für das aktuelle Attribut ein.\n\n\n\n\n", preferredStyle: .alert)
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Attribut"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Wert"
        }
        
        alertController.addTextField{ (textField) in
            textField.placeholder = "Einheit"
        }
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 65, width: 260 , height: 100))
        pickerFrame.tag = 555
        pickerFrame.delegate = self
        pickerFrame.dataSource = self
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if (alertController.textFields?[0].text?.isEmpty)! || (alertController.textFields?[1].text?.isEmpty)! || (alertController.textFields?[2].text?.isEmpty)! {
                HapticFeedback.error()
                cell.shake()
            } else {
                self.cardLabels[self.cells.index(of: cell)!].name.text = alertController.textFields?[0].text!
                self.cardLabels[self.cells.index(of: cell)!].value.text = "\((alertController.textFields?[1].text)!) \((alertController.textFields?[2].text)!)"
                self.comparisonNodes[self.cells.index(of: cell)!]!.zRotation = pickerFrame.selectedRow(inComponent: 0) == 0 ? .pi : 0
                if !self.cards.isEmpty && self.cards.keys.contains(self.curIndex) /*self.curIndex < self.cards.count*/ {
                    self.cards[self.curIndex]!.values[self.cells.index(of: cell)!] = (alertController.textFields?[1].text)!
                }
                self.attributesAndUnits[self.cells.index(of: cell)!] = ((alertController.textFields?[0].text)!, (alertController.textFields?[2].text)!, pickerFrame.selectedRow(inComponent: 0) == 0 ? "lower_wins" : "higher_wins")
                alertController.textFields?[1].text = "" // COMPARISON
            }
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.view.addSubview(pickerFrame)
        
        return alertController
    }
    
    func findValueFor(index: Int) -> String {
        if !cards.isEmpty && cards.keys.contains(curIndex) && cards[curIndex]!.values.keys.contains(index) {
            return cards[curIndex]!.values[index]!
        }
        return "Wert"
    }
    
    func findAttrAndUnitFor(index: Int) -> (name: String, unit: String, comparison: String) {
        if !attributesAndUnits.isEmpty && attributesAndUnits.keys.contains(index) {
            return attributesAndUnits[index]!
        }
        return ("Attribut", "Einheit", "lower_wins")
    }
    
    func checkAttributesAndUnits() -> [Int: ActionNode] {
        var list = [Int: ActionNode]()
        if !attributesAndUnits.isEmpty {
            for index in 0..<cells.count {
                if !attributesAndUnits.keys.contains(index) || attributesAndUnits[index]!.name == "Attribut" || attributesAndUnits[index]!.unit == "Einheit" {
                    list[index] = cells[index]
                }
            }
        } else {
            for index in 0..<cells.count {
                list[index] = cells[index]
            }
        }
        return list
    }
    
    func checkImage(at index: Int) -> ActionNode? {
        if !cards.isEmpty && cards.keys.contains(index) && cards[index]!.image != nil {
            return nil
        } else {
            return img!
        }
    }
    
    func checkName(at index: Int) -> ActionNode? {
        if !cards.isEmpty && cards.keys.contains(index) && cards[index]!.cardName != "" {
            return nil
        } else {
            return topCell
        }
    }
    
    func checkValues(at index: Int) -> [Int : ActionNode] {
        var list = [Int : ActionNode]()
        if !cards.isEmpty && cards.keys.contains(index) && !cards[index]!.values.isEmpty {
            for index2 in 0..<cells.count {
                if !cards[index]!.values.keys.contains(index2) || cards[index]!.values[index2] == "Wert" {
                    list[index2] = cells[index2]
                }
            }
        } else {
            for index2 in 0..<cells.count {
                list[index2] = cells[index2]
            }
        }
        return list
    }
    
    func nextCard() {
        if checkCard(at: curIndex, shake: true).count == 0 {
            if self.curIndex+1 < cards.count {
                self.curIndex += 1
            } else {
                //self.cardCount = cards.count
                self.curIndex += 1
                newCard()
            }
            HapticFeedback.lightFeedback()
            self.updateIndexLabel()
            self.updateCard()
        }
    }
    
    func checkCard(at index: Int, shake: Bool) -> [Int: ActionNode] {
        var list = [Int: ActionNode]()
        
        let name = checkName(at: index)
        if name != nil {
            list[-2] = name
        }
        let image = checkImage(at: index)
        if image != nil {
            list[-1] = image
        }
        for val in checkAttributesAndUnits() {
            list[val.key] = val.value
        }
        for val in checkValues(at: index) {
            list[val.key] = val.value
        }
        if shake && list.count > 0 {
            HapticFeedback.error()
            shakeDict(from: -2, list)
        }
        return list
    }
    
    func prevCard() {
        if cards.count > 1 {
            if self.curIndex > 0 {
                self.curIndex -= 1
            } else {
                self.curIndex = cards.count-1
            }
            self.updateIndexLabel()
            self.updateCard()
        }
    }
    
    func updateIndexLabel() {
        indexLabel.text = "\(curIndex+1)/\(cards.count)"
    }
    
    func newCard() {
        cards[curIndex] = (cardName: "", image: nil, values: [Int : String]())
    }
    
    func updateCard() {
        if !cards.isEmpty && cards.keys.contains(curIndex) {
            cardTitleLabel!.text = cards[curIndex]!.cardName != "" ? cards[curIndex]!.cardName : "Name"
            if cards[curIndex]!.image == nil {
                imageLabel.alpha = 1
                imageText.alpha = 1
                img!.texture = nil
            } else {
                imageLabel.alpha = 0
                imageText.alpha = 0
                img!.texture = SKTexture(image: cards[curIndex]!.image!)
            }
            for index in 0..<cardLabels.count {
                cardLabels[index].name.text = findAttrAndUnitFor(index: index).name
                if findValueFor(index: index) == "Wert" {
                    cardLabels[index].value.text = "Wert   \(findAttrAndUnitFor(index: index).unit)"
                } else {
                    cardLabels[index].value.text = "\(findValueFor(index: index))   \(findAttrAndUnitFor(index: index).unit)"
                }
            }
        } else {
            // TODO: ERROR
        }
    }
    
    func upload() {
        if cards.count >= 1 /*Values.CREATE_CARD_MIN_CARD_AMOUNT.rawValue*/ /*&& cards.count % 2 == 0*/ {
            for card in cards {
                let list = checkCard(at: card.key, shake: false)
                if list.count > 0 {
                    curIndex = card.key
                    print("jumping to card: \(card.key), list contains \(list.count)")
                    updateIndexLabel()
                    updateCard()
                    HapticFeedback.error()
                    shakeDict(from: -2, list)
                    return
                }
            }
            delegate?.prepareForUpload(cards, attributesAndUnits)
        } else {
           // TODO ALERT
        }
    }
    
    func shakeDict(from i: Int, _ list: [Int: ActionNode]) {
        var count: Double = 0
        for index in i..<10 {
            if list.keys.contains(index) {
                list[index]?.shake(delayed: 0.02 * count)
                count += 1
            }
        }
    }
    func setUpCell(withImageNamed image: String, color: UIColor, blendFactor: CGFloat, position: CGPoint, anchorPoint: CGPoint) -> ActionNode {
        let cell = ActionNode(texture: SKTexture(imageNamed: image))
        cell.color = color
        cell.colorBlendFactor = blendFactor
        cell.anchorPoint = anchorPoint
        cell.position = position
        return cell
    }
    
    func setUpLabels(for cell: SKSpriteNode) -> (name: SKLabelNode, value: SKLabelNode) {
        let nameLabel = SKLabelNode(text: "Attribut")
        nameLabel.position = CGPoint(x: (cell.size.width/2) * 0.78 * -1 , y: 0)
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.verticalAlignmentMode = .center
        nameLabel.fontColor = Color.cardText
        nameLabel.fontName = Font.cardText
        nameLabel.fontSize = 15
        let valueLabel = SKLabelNode(text: "Wert   Einheit")
        valueLabel.position = CGPoint(x: (cell.size.width/2) * 0.79, y: 0)
        valueLabel.horizontalAlignmentMode = .right
        valueLabel.verticalAlignmentMode = .center
        valueLabel.fontColor = Color.cardText
        valueLabel.fontName = Font.cardText
        valueLabel.fontSize = 15
        
        return (nameLabel, valueLabel)
    }
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return "Niedriger Wert gewinnt"
        case 1: return "Hoher Wert gewinnt"
        default: return "Niedriger Wert gewinnt"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 250
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    func didSelectImage(_ image: UIImage) {
        img!.texture = SKTexture(image: image)
        if !cards.isEmpty && cards.keys.contains(curIndex) {
            cards[curIndex]!.image = image
            imageLabel.alpha = 0
            imageText.alpha = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
