//
//  UploadUtil.swift
//  Quartett
//
//  Created by Puja Dialehabady on 07.02.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import UIKit

class UploadUtil {
    
    var deck: Deck!
    var delegate: UploadDelegate?
    let group = DispatchGroup()
    var count = 0
    var errorOccurred = false
    
    var progress: Float = 0 {
        didSet {
            guard oldValue < progress else { return }
            delegate?.updateUploadProgress(deckId: deck.id!, progress: Float(progress)/Float(count))
        }
    }
    
    init(delegate: UploadDelegate, deck: Deck, cards: [SimpleCards2],  cardsArray: [Card2], cardAttributes: [Int: [Attribut]], images: [Int: UIImage]) {
        self.delegate = delegate
        self.deck = deck
        count = 1 + 1 + cardsArray.count + cardAttributes.count + images.count
        delegate.didStartUpload(deckId: deck.id!)
        var request = HTTPRequestService.setUpPOSTRequestFor(url: "http://quartett.af-mba.dbis.info/decks/")
        
        group.enter()
        do {
        let data = try JSONEncoder().encode(deck)
            request?.httpBody = data
            print(String(data: data, encoding: .utf8))
        } catch {
            self.delegate?.didCancelUpload(deckId: deck.id!, "Beim Generieren des Kartensets ist ein Fehler aufgetreten.")
            print(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request!) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("upload deck: \(responseError)")
                self.delegate?.didCancelUpload(deckId: deck.id!, responseError?.localizedDescription)
                return
            }
            
            do {
                let newDeck = try JSONDecoder().decode(Deck.self, from: responseData!)
                print("deck id: \(newDeck.id!) vs \(deck.id!)")
            } catch {
            
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response deck: ", utf8Representation)
                //self.deck = Deck()
                //self.deck.id = utf8Representation.split(separator: ",")[0].split(separator: ":")[1].
            } else {
                print("no readable data received in response")
            }
            
            self.uploadCards(cards, cardsArray, cardAttributes, images)
            self.progress += 1
            self.group.leave()
            self.group.notify(queue: DispatchQueue.main, execute: {
                delegate.didFinishUpload(deckId: deck.id!)
            })
            
        }.resume()
        
    }
    
    func uploadCards(_ cards: [SimpleCards2], _ cardsArray: [Card2], _ cardAttributes: [Int: [Attribut]], _ images: [Int: UIImage]) {
        var request = HTTPRequestService.setUpPOSTRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/")

        group.enter()
        do {
            let data = try JSONEncoder().encode(cards)
            request?.httpBody = data
            print(String(data: data, encoding: .utf8))
        } catch {
            delegate?.didCancelUpload(deckId: deck.id!, "Beim Generieren des Kartensets ist ein Fehler aufgetreten.")
            print(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request!) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("uploadCards: \(responseError)")
                self.delegate?.didCancelUpload(deckId: self.deck.id!, responseError?.localizedDescription)
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response uploadCards: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
            
            for index in 0..<cardsArray.count {
                self.uploadCard(cardsArray[index], cardAttributes[cardsArray[index].id!]!, images[cardsArray[index].id!]!)
            }
            self.progress += 1
            self.group.leave()
            
        }.resume()
    }
    
    func uploadCard(_ card: Card2, _ cardAttribute: [Attribut],_ image: UIImage) {
        var request = HTTPRequestService.setUpPOSTRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/\(card.id!)/")
        
        group.enter()
        do {
            let data = try JSONEncoder().encode(card)
            request?.httpBody = data
        } catch {
            delegate?.didCancelUpload(deckId: deck.id!, "Beim Generieren des Kartensets ist ein Fehler aufgetreten.")
            print(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request!) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("uploadCard: \(responseError)")
                self.delegate?.didCancelUpload(deckId: self.deck.id!, responseError?.localizedDescription)
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response uploadCard: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
            
            self.uploadCardAttribute(card, cardAttribute)
            self.uploadCardImage(card, image)
            self.progress += 1
            self.group.leave()
            
        }.resume()
    }
    
    func uploadCardAttribute(_ card: Card2, _ cardAttribute: [Attribut]) {
        var request = HTTPRequestService.setUpPOSTRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/\(card.id!)/attributes/")
        
        group.enter()
        do {
            let data = try JSONEncoder().encode(cardAttribute)
            request?.httpBody = data
        } catch {
            delegate?.didCancelUpload(deckId: deck.id!, "Beim Generieren des Kartensets ist ein Fehler aufgetreten.")
            print(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request!) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("uploadCardAttribute: \(responseError)")
                self.delegate?.didCancelUpload(deckId: self.deck.id!, responseError?.localizedDescription)
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response uploadCardAttribute: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
            
            self.progress += 1
            self.group.leave()
            
        }.resume()
    }
    
    func uploadCardImage(_ card: Card2, _ image: UIImage) {
        let imageData:Data = UIImageJPEGRepresentation(image, 1.0)!
        let base64 = imageData.base64EncodedString(options: .lineLength64Characters)
        var images = [Base64Image]()
        images.append(Base64Image(description: "", order: 0, filename: "\(self.deck.name!.lowercased())_card\(card.id!)_0", image_base64: base64))
        var request = HTTPRequestService.setUpPOSTRequestFor(url: "http://quartett.af-mba.dbis.info/decks/\(deck.id!)/cards/\(card.id!)/images/")
        
        group.enter()
        do {
            let data = try JSONEncoder().encode(images)
            request?.httpBody = data
        } catch {
            delegate?.didCancelUpload(deckId: deck.id!, "Beim Generieren des Kartensets ist ein Fehler aufgetreten.")
            print(error)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request!) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("uploadCardImage: \(responseError)")
                self.delegate?.didCancelUpload(deckId: self.deck.id!, responseError?.localizedDescription)
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response uploadCardImage: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
            
            self.progress += 1
            self.group.leave()
        }.resume()
    }
}
