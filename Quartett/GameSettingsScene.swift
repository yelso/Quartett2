//
//  GameSettingsScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 28.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class GameSettingsScene: SKScene {

    var buttonArray = [GroupActionNode]()
    var startGameButton: ActionNode!
    var buttonPlus: ActionNode!
    var backButton: ActionNode!
    var settings: GameSettings = GameSettings()
    var didSelectRounds = false
    var didSelectDifficulty = false
    var didSelectCardSet = false
    
    override func didMove(to view: SKView) {
        settings.difficulty = 1
        settings.cardSetName = "tuning"
        settings.maxRounds = 10

        // Group Round Buttons
        buttonArray.append(GroupActionNode(color: Color.blue1, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.blue2, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.blue3, size: CGSize(width: 105, height: 50)))
        
        
        //Group Difficulty Button
        buttonArray.append(GroupActionNode(color: Color.lightOrange, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.softOrange, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.darkOrange, size: CGSize(width: 105, height: 50)))
    
        //Start Button
        startGameButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))
        startGameButton.position = CGPoint(x: self.size.width/2 * 0.65 , y: self.size.height/2 * 0.85 * -1)

        startGameButton.setScale(0.01)
        startGameButton.isUserInteractionEnabled = false
        startGameButton.isHidden = true
        
        //Back Button
        backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange")) 
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        
        
        buttonArray[0].position = CGPoint(x: -110, y: 220)
        buttonArray[1].position = CGPoint(x: 0, y: 220)
        buttonArray[2].position = CGPoint(x: 110, y: 220)
        
        buttonArray[3].position = CGPoint(x: -110, y: 80)
        buttonArray[4].position = CGPoint(x: 0, y: 80)
        buttonArray[5].position = CGPoint(x: 110, y: 80)
   
        //Labels
        let roundsLabel =  SKLabelNode(text: "Runden")
        let difficultyLabel =  SKLabelNode(text: "Schwierigkeit")
        let cardSetLabel = SKLabelNode(text: "Kartenset")
        
        roundsLabel.fontName = Font.buttonFont
        difficultyLabel.fontName = Font.buttonFont
        cardSetLabel.fontName = Font.buttonFont
        
        roundsLabel.position = CGPoint(x: -160, y: 260)
        difficultyLabel.position = CGPoint(x: -160, y: 120)
        cardSetLabel.position = CGPoint(x: -160, y:-20)
        
        roundsLabel.horizontalAlignmentMode = .left
        difficultyLabel.horizontalAlignmentMode = .left
        cardSetLabel.horizontalAlignmentMode = .left
        
        //Round Button Text
        let rounds10 =  SKLabelNode(text: "10")
        let rounds20 =  SKLabelNode(text: "20")
        let roundsInf =  SKLabelNode(text: "∞")
        
        rounds10.fontName = Font.buttonFont
        rounds20.fontName = Font.buttonFont
        roundsInf.fontName = Font.buttonFont
        
        rounds10.fontSize = 30
        rounds20.fontSize = 30
        roundsInf.fontSize = 40

        rounds10.verticalAlignmentMode = .center
        rounds20.verticalAlignmentMode = .center
        roundsInf.verticalAlignmentMode = .center
        
        buttonArray[0].addChild(rounds10)
        buttonArray[1].addChild(rounds20)
        buttonArray[2].addChild(roundsInf)
        
        //Difficulty Button Text
        let difficulttyE =  SKLabelNode(text: "Leicht")
        let difficulttyM =  SKLabelNode(text: "Mittel")
        let difficulttyH =  SKLabelNode(text: "Schwer")
        
        difficulttyE.fontSize = 25
        difficulttyM.fontSize = 25
        difficulttyH.fontSize = 25
        
        difficulttyE.fontName = Font.buttonFont
        difficulttyM.fontName = Font.buttonFont
        difficulttyH.fontName = Font.buttonFont
        
        difficulttyE.verticalAlignmentMode = .center
        difficulttyM.verticalAlignmentMode = .center
        difficulttyH.verticalAlignmentMode = .center
        
        buttonArray[3].addChild(difficulttyE)
        buttonArray[4].addChild(difficulttyM)
        buttonArray[5].addChild(difficulttyH)
        
        //CardSetButtons 
        let cardSetNamesArray = FileUtils.filesWithExtension()
        let multi  = (1-0.2)/CGFloat(cardSetNamesArray.count)
        
        var cardSetButtonArray = [GroupActionNode]()
        for index in 0..<cardSetNamesArray.count {
            let green = UIColor(red: 0.01, green: 0.8-(CGFloat(index) * multi) + 0.2, blue: 0.05, alpha: 1.0)
            let button = GroupActionNode(color: green, size: CGSize(width: 105, height: 50))
            button.position = CGPoint(x: -110 + index%3 * 110, y: -60 - Int(index/3) * 55)
            
            let cardLabel = SKLabelNode(text: "\(cardSetNamesArray[index].dropLast(5))")
            cardLabel.verticalAlignmentMode = .center
            cardLabel.fontName = Font.buttonFont
            button.addChild(cardLabel)
            
            cardSetButtonArray.append(button)
            buttonArray.append(button)
            
            button.action = {
                self.settings.cardSetName = "\(cardSetNamesArray[index].dropLast(5))"
                self.didSelectCardSet = true
                self.showStartButton()
            }
        }
        
        buttonPlus = ActionNode(color: UIColor(red: 0.01, green: 0.8-(CGFloat(cardSetButtonArray.count) * multi) + 0.2, blue: 0.05, alpha: 1.0), size: CGSize(width: 105, height: 50))
        buttonPlus.position = CGPoint(x: -110 + (cardSetButtonArray.count)%3 * 110, y: -60 - Int((cardSetButtonArray.count)/3) * 55)
        let cardLabel = SKLabelNode(text: "+")
        cardLabel.verticalAlignmentMode = .center
        cardLabel.fontName = Font.buttonFont
        buttonPlus.addChild(cardLabel)
    
        
        //Add Buttons
        self.addChild(buttonPlus)
        self.addChild(roundsLabel)
        self.addChild(difficultyLabel)
        self.addChild(cardSetLabel)
        self.addChild(startGameButton)
        self.addChild(backButton)
        for node in buttonArray {
            self.addChild(node)
        }
        
        buttonArray[0].setUpGroup([buttonArray[0], buttonArray[1], buttonArray[2]])
        buttonArray[3].setUpGroup([buttonArray[3], buttonArray[4],buttonArray[5]])
        buttonArray[6].setUpGroup(cardSetButtonArray)
        
        buttonArray[0].action = {
            self.settings.maxRounds = 10
            self.didSelectRounds = true
            self.showStartButton()
        }
        buttonArray[1].action = {
            self.settings.maxRounds = 20
            self.didSelectRounds = true
            self.showStartButton()
        }
        buttonArray[2].action = {
            self.settings.maxRounds = -1
            self.didSelectRounds = true
            self.showStartButton()
        }
        
        buttonArray[3].action = {
            self.settings.difficulty = 0
            self.didSelectDifficulty = true
            self.showStartButton()
        }
        buttonArray[4].action = {
            self.settings.difficulty = 1
            self.didSelectDifficulty = true
            self.showStartButton()
        }
        buttonArray[5].action = {
            self.settings.difficulty = 2
            self.didSelectDifficulty = true
            self.showStartButton()
        }
        buttonPlus.action = {
            if let scene = SKScene(fileNamed: "StoreScene") as? StoreScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                scene.origin = "GameSettingScene"
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        
        for index in 0..<buttonArray.count {
            buttonArray[index].customAnimationEnabled = true
            buttonArray[index].isHighlightButton = true
            
            buttonArray[index].onTouch = {
                self.buttonArray[index].run(self.buttonArray[index].defaultOnTouchAnimation())
            }
            buttonArray[index].onTouchEnd = {
                self.buttonArray[index].run(self.buttonArray[index].defaultOnTouchEndAnimation())
            }
            buttonArray[index].onTouchEndInside = {
                let scaleAction = SKAction.scale(to: 1.00, duration: 0.15)
                let colorizeAction = SKAction.colorize(with: self.buttonArray[index].initialColor!, colorBlendFactor: 1, duration: 0.15)
                self.buttonArray[index].run(SKAction.group([scaleAction, colorizeAction]))
                
            }
            buttonArray[index].onTouchEndInsideGroup = {
                for member in self.buttonArray[index].group {
                    member.colorBlendFactor = 0
                    member.color = UIColor.gray
                }
            }
        }
        
        startGameButton.action = {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.game = Game(withSettings: self.settings)
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .left, duration: 0.5)
                // Present the scene
                view.presentScene(scene, transition: transition)
            }
        }
        backButton.action = {
            if let scene = SKScene(fileNamed: "MainMenuScene") as? MainMenuScene {
                scene.scaleMode = .aspectFill
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
    }
    
    func showStartButton() {
        if didSelectRounds && didSelectDifficulty && didSelectCardSet {
            guard startGameButton.isHidden else { return }
            startGameButton.isHidden = false
            // animation
            let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.15)
            let scaleNormalAction = SKAction.scale(to: 1.0, duration: 0.15)
            let scaleDownAction = SKAction.scale(to: 0.8, duration: 0.15)
            startGameButton.run(SKAction.sequence([scaleUpAction, scaleDownAction, scaleNormalAction, SKAction.run({self.startGameButton.isUserInteractionEnabled = true})]))
        }
    }
    
}
