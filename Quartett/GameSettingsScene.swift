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
    var backButton: ActionNode!
    var settings: GameSettings = GameSettings()
    var didSelectRounds = false
    var didSelectDifficulty = false
    var didSelectCardSet = false
    
    override func didMove(to view: SKView) {
        if UIScreen.main.bounds.height == 812 { // all but iPhone X
            self.setScale(0.85)
        }
        settings.difficulty = 1
        settings.cardSetName = "tuning"
        settings.maxRounds = 10

        // Group Round Buttons
        buttonArray.append(GroupActionNode(color: Color.blue1, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.blue2, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.blue3, size: CGSize(width: 105, height: 50)))
        
        
        //Group Difficulty Button
        buttonArray.append(GroupActionNode(color: Color.lightOrange, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.middleOrange, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.darkOrange, size: CGSize(width: 105, height: 50)))
   
        //Group Cardset
        buttonArray.append(GroupActionNode(color: Color.green1, size: CGSize(width: 105, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.green2, size: CGSize(width: 105, height: 50)))
    
        //Start Button
        startGameButton = ActionNode(texture: SKTexture(imageNamed: "nextButtonOrange"))// ActionNode(color: Color.background, size: CGSize(width: 110, height: 50))
        startGameButton.position = CGPoint(x: self.size.width/2 * 0.65 , y: self.size.height/2 * 0.85 * -1)

        startGameButton.setScale(0.01)
        startGameButton.isUserInteractionEnabled = false
        startGameButton.isHidden = true
        
        //Back Button
        backButton = ActionNode(texture: SKTexture(imageNamed: "closeButton")) //ActionNode(color: Color.background, size: CGSize(width: 110, height: 50))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        
        
        buttonArray[0].position = CGPoint(x: -110, y: 220)
        buttonArray[1].position = CGPoint(x: 0, y: 220)
        buttonArray[2].position = CGPoint(x: 110, y: 220)
        
        buttonArray[3].position = CGPoint(x: -110, y: 80)
        buttonArray[4].position = CGPoint(x: 0, y: 80)
        buttonArray[5].position = CGPoint(x: 110, y: 80)
        
        buttonArray[6].position = CGPoint(x: -110, y: -60)
        buttonArray[7].position = CGPoint(x: 0, y: -60)
        
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
        
        //Cardset Button Text
        let cardSet1 = SKLabelNode(text: CardSets.tuning.rawValue)
        let cardSet2 = SKLabelNode(text: CardSets.bikes.rawValue)
        
        cardSet1.fontSize = 30
        cardSet2.fontSize = 30
        
        cardSet1.fontName = Font.buttonFont
        cardSet2.fontName = Font.buttonFont
        
        cardSet1.verticalAlignmentMode = .center
        cardSet2.verticalAlignmentMode = .center
        
        buttonArray[6].addChild(cardSet1)
        buttonArray[7].addChild(cardSet2)
        
        //Add Buttons
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
        buttonArray[6].setUpGroup([buttonArray[6], buttonArray[7]])
        
        buttonArray[0].action = {
            self.settings.maxRounds = 1
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
        buttonArray[6].action = {
            self.settings.cardSetName = CardSets.tuning.rawValue
            self.didSelectCardSet = true
            self.showStartButton()
        }
        buttonArray[7].action = {
            self.settings.cardSetName = CardSets.bikes.rawValue
            self.didSelectCardSet = true
            self.showStartButton()
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
