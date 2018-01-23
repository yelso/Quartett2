//
//  StoreScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 10.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class StoreScene: SKScene, DownloadDelegate {
    
    let group = DispatchGroup()
    var cards2 = [Int: Card2]()
    var attributes = [Int: [Attribut]]()
    var images2 = [Int: [Image2]]()
    //var images = [Int: [Image]]()
    var downloads = [CardDownload]()
    
    
    override func didMove(to view: SKView) {
        let backButton = ActionNode(texture: SKTexture(imageNamed: "backButtonOrange"))
        backButton.position = CGPoint(x: self.size.width/2 * 0.65 * -1, y: self.size.height/2 * 0.85 * -1)
        backButton.action = {
            if let scene = SKScene(fileNamed: "MainMenuScene") as? MainMenuScene {
                scene.scaleMode = .aspectFill
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
        
        let request = CardDownload.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/")
        
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
                        let cell = ActionNode(color: Color.darkOrange, size: CGSize(width: 320, height: 50))
                        cell.position = CGPoint(x: 0, y: 180 - (index * 60))
                        cell.action = {
                            self.downloads.append(CardDownload(delegate: self, deck: decks[index]))
                            //self.loadCardsFor(deck: decks[index])
                        }
                        //let cardNode = SKSpriteNode(color: Color.darkOrange, size: CGSize(width: 320, height: 50))
                        //cardNode.position = CGPoint(x: 0, y: 0)//180 - (index * 60))-135
                        let labelNode = SKLabelNode(text: decks[index].name)
                        labelNode.position = CGPoint(x: 0, y: 0)//180 - (index * 60))-100
                        labelNode.horizontalAlignmentMode = .center
                        labelNode.fontName = Font.buttonFont
                        labelNode.fontColor = .white
                        labelNode.fontSize = title.fontSize-4.0
                        labelNode.verticalAlignmentMode = .center
                        cell.addChild(labelNode)
                        //cell.addChild(cardNode)
                        self.addChild(cell)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    /*
    func loadCardsFor(deck: Deck) {
        let request = self.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let cards = try JSONDecoder().decode([Card2].self, from: data)
                self.cards2.removeAll()
                for index in 0..<cards.count {
                    self.loadCardWith(id: cards[index].id!, setId: deck.id!)
                }
                self.group.leave()
                self.group.notify(queue: DispatchQueue.main, execute: {
                    self.save(deck)
                })
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func loadCardWith(id: Int, setId: Int) {
        let request = self.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(setId)/cards/\(id)/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                var card = try JSONDecoder().decode(Card2.self, from: data)
                self.cards2[card.id!] = card
                self.loadAttributesFor(card: card, setId: setId)
                self.loadImagesFor(card: card, setId: setId)
                self.group.leave()
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }

    func loadAttributesFor(card: Card2, setId: Int) {//id: Int, setId: Int) -> [Attribut] {
        let request = self.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(setId)/cards/\(card.id!)/attributes/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                self.attributes[card.id!] = try JSONDecoder().decode([Attribut].self, from: data)
                self.group.leave()
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func loadImagesFor(card: Card2, setId: Int) {//id: Int, setId: Int) -> [Attribut] {
        let request = self.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(setId)/cards/\(card.id!)/images/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                self.images2[card.id!] = try JSONDecoder().decode([Image2].self, from: data)
                self.group.leave()
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func save(_ deck: Deck) {
        
        let cardSet = createCardSet(with: deck)
        print(cardSet.name)
        /*
        let file: FileHandle? = FileHandle(forWritingAtPath: "\(name!).json")
        
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
        }*/
    }
 
    func createCardSet(with deck: Deck) -> CardSet {
        var valueIds = [String: String]()
        var properties = [Property]()
        for index in 0..<(attributes.first?.value)!.count {
            let attribute = (attributes.first?.value[index])!
            properties.append(Property(withText: attribute.name!, compare: attribute.what_wins?.lowercased() == "higher_wins" ? "1" : "-1" , id: "\(index)", unit: attribute.unit!, precision: ""))
            valueIds[attribute.name!.lowercased()] = "\(index)"
        }
        
        var cards = [Card]()
        for card2 in cards2.values {
            var values = [Value]()
            let attr = attributes[card2.id!]!
            for val in attr {
                values.append(Value(value: val.value!, propertyId: valueIds[val.name!.lowercased()]!))
            }
            var images = [Image]()
            for index in 0..<images2[card2.id!]!.count {
                let img = images2[card2.id!]![index]
                let imgName = "\(img.image!.components(separatedBy: "/").last!.components(separatedBy: ".").first!)"
                images.append(Image(id: "\(img.id!)", filename: "\(deck.name!)"))
                for n2 in img.image!.components(separatedBy: "/") {
                    print("[\(card2.id!)] comp: \(n2)")
                }
                print("\(img.image!.components(separatedBy: "/").last!.components(separatedBy: ".").first!)")
            }
            let card = Card(withId: "\(card2.id)", name: card2.name!, description: Description(), values: values, images: images)
            cards.append(card)
        }
    
        return CardSet(withName: deck.name!, cards: cards, description: Description(), properties: properties)
    }
 
    func setUpRequestFor(url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic c3R1ZGVudDphZm1iYQ==", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
     */
    func didStartdownload(deckId: Int) {
        
    }
    
    func didFinishDownload(deckId: Int) {
        
    }
    
    func didCancelDownload(deckId: Int) {
        
    }
}
