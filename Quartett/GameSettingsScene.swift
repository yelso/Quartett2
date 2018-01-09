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
    
    override func didMove(to view: SKView) {
        settings.difficulty = 1
        settings.cardSetName = "tuning"
        settings.maxRounds = 10

        // Group Round Buttons
        buttonArray.append(GroupActionNode(color: Color.blue1, size: CGSize(width: 110, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.blue2, size: CGSize(width: 110, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.blue3, size: CGSize(width: 110, height: 50)))
        
        
        //Group Difficulty Button
        buttonArray.append(GroupActionNode(color: Color.lightOrange, size: CGSize(width: 110, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.middleOrange, size: CGSize(width: 110, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.darkOrange, size: CGSize(width: 110, height: 50)))
   
        //Group Cardset
        buttonArray.append(GroupActionNode(color: Color.green1, size: CGSize(width: 110, height: 50)))
        buttonArray.append(GroupActionNode(color: Color.green2, size: CGSize(width: 110, height: 50)))
    
        //Start Button
        startGameButton = GroupActionNode(color: Color.background, size: CGSize(width: 110, height: 50))
        let startLabel = SKLabelNode(text: "Start >")
        startGameButton.position = CGPoint(x: 130, y: -320)
        startLabel.fontSize = 25
        //startLabel.verticalAlignmentMode = .center
        startGameButton.addChild(startLabel)
        
        //Back Button
        backButton = GroupActionNode(color: Color.background, size: CGSize(width: 110, height: 50))
        let endLabel = SKLabelNode(text: "< Zurück")
        backButton.position = CGPoint(x: -130, y: -320)
        endLabel.fontSize = 25
        //endLabel.verticalAlignmentMode = .center
        backButton.addChild(endLabel)
        
        
        buttonArray[0].position = CGPoint(x: -125, y: 220)
        buttonArray[1].position = CGPoint(x: -10, y: 220)
        buttonArray[2].position = CGPoint(x: 105, y: 220)
        
        buttonArray[3].position = CGPoint(x: -125, y: 80)
        buttonArray[4].position = CGPoint(x: -10, y: 80)
        buttonArray[5].position = CGPoint(x: 105, y: 80)
        
        buttonArray[6].position = CGPoint(x: -125, y: -60)
        buttonArray[7].position = CGPoint(x: -10, y: -60)
        
        //Labels
        let roundsLabel =  SKLabelNode(text: "Runden")
        let difficultyLabel =  SKLabelNode(text: "Schwierigkeit")
        let cardSetLabel = SKLabelNode(text: "Kartenset")
        
        roundsLabel.position = CGPoint(x: -180, y: 260)
        difficultyLabel.position = CGPoint(x: -180, y: 120)
        cardSetLabel.position = CGPoint(x: -180, y:-20)
        
        roundsLabel.horizontalAlignmentMode = .left
        difficultyLabel.horizontalAlignmentMode = .left
        cardSetLabel.horizontalAlignmentMode = .left
        
        //Round Button Text
        let rounds10 =  SKLabelNode(text: "10")
        let rounds20 =  SKLabelNode(text: "20")
        let roundsInf =  SKLabelNode(text: "∞")
        
        rounds10.fontSize = 30
        rounds20.fontSize = 30
        roundsInf.fontSize = 30

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
        
        difficulttyE.verticalAlignmentMode = .center
        difficulttyM.verticalAlignmentMode = .center
        difficulttyH.verticalAlignmentMode = .center
        
        buttonArray[3].addChild(difficulttyE)
        buttonArray[4].addChild(difficulttyM)
        buttonArray[5].addChild(difficulttyH)
        
        //Cardset Button Text
        let cardSet1 = SKLabelNode(text: "Karten 1")
        let cardSet2 = SKLabelNode(text: "Karten 2")
        
        cardSet1.fontSize = 25
        cardSet2.fontSize = 25
        
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
        self.addChild(buttonArray[0])
        self.addChild(buttonArray[1])
        self.addChild(buttonArray[2])
        self.addChild(buttonArray[3])
        self.addChild(buttonArray[4])
        self.addChild(buttonArray[5])
        self.addChild(buttonArray[6])
        self.addChild(buttonArray[7])
        
        
        buttonArray[0].setUpGroup([buttonArray[0], buttonArray[1], buttonArray[2]])
        buttonArray[3].setUpGroup([buttonArray[3], buttonArray[4],buttonArray[5]])
        buttonArray[6].setUpGroup([buttonArray[6], buttonArray[7]])
        
        buttonArray[0].action = {
            self.settings.maxRounds = 10
        }
        buttonArray[1].action = {
            self.settings.maxRounds = 20
        }
        buttonArray[2].action = {
            self.settings.maxRounds = -1
        }
        
        buttonArray[3].action = {
            self.settings.difficulty = 0
        }
        buttonArray[4].action = {
            self.settings.difficulty = 1
        }
        buttonArray[5].action = {
            self.settings.difficulty = 2
        }
        buttonArray[6].action = {
            self.settings.cardSetName = "Karten1"
        }
        buttonArray[6].action = {
            self.settings.cardSetName = "Karten2"
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
    }
    
}
