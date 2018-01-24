//
//  CardDownloadService.swift
//  Quartett
//
//  Created by Puja Dialehabady on 23.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation

class HTTPRequestService {
    static func setUpRequestFor(url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic c3R1ZGVudDphZm1iYQ==", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}

class DownloadUtil {
    
    var delegate: DownloadDelegate?
    let group = DispatchGroup()
    var cards2 = [Int: Card2]()
    var attributes = [Int: [Attribut]]()
    var images2 = [Int: [Image2]]()
    let deck: Deck!
    var count = 0
    var progress = 0 {
        didSet {
            guard oldValue < progress else { return }
            delegate?.updateProgess(deckId: deck.id!, progress: Float(progress)/Float(count))
        }
    }
    
    init(delegate: DownloadDelegate, deck: Deck) {
        self.deck = deck
        self.delegate = delegate
        let request = HTTPRequestService.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let cards = try JSONDecoder().decode([Card2].self, from: data)
                self.cards2.removeAll()
                self.count = cards.count * 3 + 2
                for index in 0..<cards.count {
                    self.loadCard(for: deck, id: cards[index].id!, index: index, count: cards.count)
                }
                self.group.leave()
                self.group.notify(queue: DispatchQueue.main, execute: {
                    self.save(deck)
                })
            } catch let jsonError {
                self.delegate?.didCancelDownload(deckId: deck.id!)
                print(jsonError)
            }
        }.resume()
    }
    
    func loadCard(for deck: Deck, id: Int, index: Int, count: Int) {
        let request = HTTPRequestService.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/\(id)/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let card = try JSONDecoder().decode(Card2.self, from: data)
                self.cards2[card.id!] = card
                self.loadAttributesFor(card: card)
                self.loadImagesFor(card: card)
                self.progress += 1
                self.group.leave()
            } catch let jsonError {
                self.delegate?.didCancelDownload(deckId: self.deck.id!)
                print(jsonError)
            }
            }.resume()
    }
    
    func loadAttributesFor(card: Card2) {
        let request = HTTPRequestService.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/\(card.id!)/attributes/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                self.attributes[card.id!] = try JSONDecoder().decode([Attribut].self, from: data)
                self.progress += 1
                self.group.leave()
            } catch let jsonError {
                self.delegate?.didCancelDownload(deckId: self.deck.id!)
                print(jsonError)
            }
            }.resume()
    }
    
    func loadImagesFor(card: Card2) {
        let request = HTTPRequestService.setUpRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/\(card.id!)/images/")
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                self.images2[card.id!] = try JSONDecoder().decode([Image2].self, from: data)
                for index in 0..<self.images2[card.id!]!.count {
                    self.loadImage(self.images2[card.id!]![index], card, index)
                }
                self.progress += 1
                self.group.leave()
            } catch let jsonError {
                self.delegate?.didCancelDownload(deckId: self.deck.id!)
                print(jsonError)
            }
        }.resume()
    }
    
    func loadImage(_ img: Image2, _ card: Card2, _ index: Int) {
        let request = HTTPRequestService.setUpRequestFor(url: img.image!)
        group.enter()
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            FileUtils.saveImage(data, name: "\(self.deck.name!.lowercased())_card\(card.id!)_0")
            self.group.leave()
        }.resume()
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
                images.append(Image(id: "\(img.id!)", filename: "\(deck.name!.lowercased())_card\(card2.id!)_0"))
            }
            
            let card = Card(withId: "\(card2.id!)", name: card2.name!, description: Description(), values: values, images: images)
            cards.append(card)
        }
        
        progress += 1
        return CardSet(withName: deck.name!, cards: cards, description: Description(), properties: properties)
    }
    
    func save(_ deck: Deck) {
        
        let cardSet = createCardSet(with: deck)
        
        if FileUtils.save(cardSet, as: cardSet.name.lowercased() + ".json") {
            progress += 1
            delegate?.didFinishDownload(deckId: deck.id!)
        } else {
            delegate?.didCancelDownload(deckId: deck.id!)
        }
    }
}
