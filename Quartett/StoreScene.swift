//
//  StoreScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 10.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class StoreScene: SKScene {
    
    let group = DispatchGroup()
    var cards = [Int: Card2]()
    var attributes = [Attribut]()

    override func didMove(to view: SKView) {
        let backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        backButton.action = {
            if let scene = SKScene(fileNamed: "MainMenuScene") as? MainMenuScene {
                let transition = SKTransition.push(with: .right, duration: 0.5)
                view.presentScene(scene, transition: transition)
            }
        }
        self.addChild(backButton)
        
        let title = SKLabelNode(text: "Store")
        title.fontName = Font.buttonFont
        title.position = CGPoint(x: -160, y: 260)
        title.horizontalAlignmentMode = .left
        self.addChild(title)
        
        let request = setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/")
        
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let decks = try JSONDecoder().decode([Deck].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    FileUtils.filesWithExtension()
                    for index in 0..<decks.count {
                        let cell = ActionNode(color: UIColor.clear, size: CGSize(width: 400, height: 50))
                        cell.position = CGPoint(x: 0, y: 180 - (index * 60))
                        cell.action = {
                            self.loadCardsFor(deck: decks[index])
                        }
                        let cardNode = SKSpriteNode(color: Color.darkOrange, size: CGSize(width: 50, height: 50))
                        cardNode.position = CGPoint(x: -135, y: 0)//180 - (index * 60))
                        let labelNode = SKLabelNode(text: decks[index].name)
                        labelNode.position = CGPoint(x: -100, y: 0)//180 - (index * 60))
                        labelNode.horizontalAlignmentMode = .left
                        labelNode.fontName = Font.buttonFont
                        labelNode.fontSize = title.fontSize-4.0
                        labelNode.verticalAlignmentMode = .center
                        cell.addChild(labelNode)
                        cell.addChild(cardNode)
                        self.addChild(cell)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func loadCardSets() {}
    
    func loadCardsFor(deck: Deck) {
        let request = self.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/")
        print(Thread.current)
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            print(Thread.current)
            do {
                let cards = try JSONDecoder().decode([Card2].self, from: data)
                self.cards.removeAll()
                for index in 0..<cards.count {
                    print("\(cards[index].id!): \(cards[index].name!)")
                    self.loadCardWith(id: cards[index].id!, setId: deck.id!)
                }
                self.group.leave()
                self.group.notify(queue: DispatchQueue.main, execute: {
                    print("DONE")
                    self.saveCardSet(name: deck.name!, set: deck)
                })
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func loadCardWith(id: Int, setId: Int) {
        let request = self.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(setId)/cards/\(id)/")
        print("load: \(Thread.current)")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            print("in: \(Thread.current)")
            do {
                var card = try JSONDecoder().decode(Card2.self, from: data)
                self.cards[card.id!] = card
                self.loadAttributesFor(card: &card, setId: setId)
                self.group.leave()
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }

    func loadAttributesFor(card: inout Card2, setId: Int) {//id: Int, setId: Int) -> [Attribut] {
        let request = self.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(setId)/cards/\(card.id!)/attributes/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                self.attributes = try JSONDecoder().decode([Attribut].self, from: data)
                self.group.leave()
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func saveCardSet(name named: String, set: Deck) {
        
        let file: FileHandle? = FileHandle(forWritingAtPath: "\(name).json")
        
        if file != nil {
            // Set the data we want to write
            do{
                if let jsonData = try JSONSerialization.data(withJSONObject: set, options: .init(rawValue: 0)) as? Data
                {
                    // Check if everything went well
                    print(NSString(data: jsonData, encoding: 1)!)
                    file?.write(jsonData)
                    
                    // Do something cool with the new JSON data
                }
            }
            catch {
                
            }
            // Write it to the file
            
            // Close the file
            file?.closeFile()
        }
        else {
            print("Ooops! Something went wrong!")
        }
    }
 
 
    func setUpRequestFor(url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic c3R1ZGVudDphZm1iYQ==", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
