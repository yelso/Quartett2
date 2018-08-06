//
//  CreateCardSetScene.swift
//  Quartett
//
//  Created by Puja Dialehabady on 24.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import Photos

class CreateCardSetScene: SKScene, CreateCardDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UploadDelegate {
    
    let imagePickerController = UIImagePickerController()
    var cardNode: CreateCardNode!
    var loadingAlert: UIAlertController?
    var errorAlert: UIAlertController?
    var progressAlert: UIAlertController?
    var progressView: UIProgressView?
    var loadingIndicator: UIActivityIndicatorView?
    
    override func didMove(to view: SKView) {
        cardNode = CreateCardNode(view: view, color: .clear, size: self.size, position: CGPoint(x: 0, y: 0), delegate: self)
        self.addChild(cardNode)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    func didStartUpload(deckId: Int) {
        DispatchQueue.main.async {
            self.loadingAlert?.dismiss(animated: true, completion: {
                self.loadingAlert = nil
                if self.progressAlert == nil {
                    self.progressAlert = UIAlertController(title: "Hochladen..", message: "Bitte schließe die App während dieser Aktion nicht.\n\n\n", preferredStyle: .alert)
                    
                    self.progressView = UIProgressView(frame: CGRect(x: 15, y: 100, width: 240, height: 5))
                    
                    self.progressAlert?.view.addSubview(self.progressView!)
                    self.view?.window?.rootViewController?.present(self.progressAlert!, animated: true, completion: nil)
                }
            })
        }
    }
    
    func didFinishUpload(deckId: Int) {
        DispatchQueue.main.async {
            self.progressAlert?.dismiss(animated: true, completion: {
                self.progressAlert = nil
                self.progressView = nil
                let finishAlert = UIAlertController(title: "Abgeschlossen", message: "Dein Kartenset wurde erfolgreich hochgeladen.", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    if let scene = SKScene(fileNamed: "StoreScene") as? StoreScene {
                        //nameTextField.removeFromSuperview()
                        scene.scaleMode = .aspectFill
                        let transition = SKTransition.push(with: .right, duration: 0.5)
                        self.view?.presentScene(scene, transition: transition)
                    }
                })
                finishAlert.addAction(dismissAction)
                self.view?.window?.rootViewController?.present(finishAlert, animated: true, completion: nil)
             })
        }
    }
    
    func didCancelUpload(deckId: Int, _ error: String?) {
        DispatchQueue.main.async {
            if self.loadingAlert != nil {
                self.loadingAlert?.dismiss(animated: true, completion: {
                    self.loadingAlert = nil
                    if self.progressAlert != nil {
                        self.progressAlert?.dismiss(animated: true, completion: {
                            self.progressAlert = nil
                            self.progressView = nil
                            self.showError(error)
                        })
                    } else {
                        self.showError(error)
                    }
                })
                
            } else if self.progressAlert != nil {
                self.progressAlert?.dismiss(animated: true, completion: {
                    self.progressAlert = nil
                    self.progressView = nil
                    self.showError(error)
                })
            } else {
                self.showError(error)
            }
        }
    }
    
    func updateUploadProgress(deckId: Int, progress: Float) {
        DispatchQueue.main.async {
            self.progressView?.progress = progress
        }
    }
    
    func showError(_ error: String?) {
        DispatchQueue.main.async {
            if self.errorAlert == nil {
                self.errorAlert = UIAlertController(title: "Error", message: error == nil ? "Es ist ein Fehler aufgetreten. Bitte versuche es später erneut." : error, preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.errorAlert = nil
                }
                self.errorAlert!.addAction(dismissAction)
                self.view?.window?.rootViewController?.present(self.errorAlert!, animated: true, completion: nil)
            }
        }
    }
    
    func prepareForUpload(_ cards: [Int : (cardName: String, image: UIImage?, values: [Int : String])], _ attrAndUnits: [Int : (name: String, unit: String, comparison: String)]) {
        DispatchQueue.main.async {
        let alertController = UIAlertController(title: "Name eingeben", message: "Gib den Namen für das Kartenset ein.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (_) in }
        let confirmAction = UIAlertAction(title: "Hochladen", style: .default) { (_) in
            
            if (alertController.textFields?[0].text?.isEmpty)! {
                HapticFeedback.error()
                self.cardNode.shake()
            } else {
                let text = alertController.textFields?[0].text!.lowercased()
                DispatchQueue.main.async {
                self.loadingAlert = UIAlertController(title: nil, message: "Überprüfen..", preferredStyle: .alert)
                
                self.loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                self.loadingIndicator!.hidesWhenStopped = true
                self.loadingIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                self.loadingIndicator!.startAnimating();
                
                self.loadingAlert?.view.addSubview(self.loadingIndicator!)
                self.view?.window?.rootViewController?.present(self.loadingAlert!, animated: true, completion: nil)
                }
                let request = HTTPRequestService.setUpGETRequestFor(url: "http://quartett.af-mba.dbis.info/decks/")
                URLSession.shared.dataTask(with: request!) { data, response, error in
                    if error != nil {
                        print(error!.localizedDescription)
                        self.showError(error?.localizedDescription)
                    }
                    guard let data = data else { return }
                    do {
                        let decks = try JSONDecoder().decode([Deck].self, from: data)
                        //Get back to the main queue
                        if decks.count > 0 {
                            var id = 0
                            var nameInUse = false
                            for deck in decks {
                                if deck.name!.lowercased() == text {
                                    nameInUse = true
                                    break
                                } else {
                                    if deck.id! > id {
                                        id = deck.id!
                                    }
                                }
                            }
                            
                            if !nameInUse {
                                DispatchQueue.main.async {
                                    self.tryToUpload(Deck(id: (id + 1), name: alertController.textFields?[0].text!, image: ""), cards, attrAndUnits)
                                }
                            } else {
                                self.showError("Der eingegebene Kartenset-Name wird bereits verwendet")
                            }
                            
                        }
                        
                    } catch let jsonError {
                        print(jsonError)
                    }
                    }.resume()
            }
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func tryToUpload(_ deck: Deck, _ cards: [Int : (cardName: String, image: UIImage?, values: [Int : String])], _ attrAndUnits: [Int : (name: String, unit: String, comparison: String)]) {
    
        var newCards = [Card2]()
        var newCardsSimple = [SimpleCards2]()
        var newCardAttributes = [Int: [Attribut]]()
        var images = [Int : UIImage]()
        for cardIndex in 0..<cards.count {
            var newAttributes = [Attribut]()
            for index in 0..<attrAndUnits.count {
                newAttributes.append(Attribut(id: index+1, card: cardIndex+1, name: attrAndUnits[index]?.name, value: cards[cardIndex]?.values[index], unit: attrAndUnits[index]?.unit, what_wins: attrAndUnits[index]?.comparison, image: ""))
            }
            newCardAttributes[cardIndex+1] = newAttributes
            newCardsSimple.append(SimpleCards2(id: cardIndex+1, name: cards[cardIndex]!.cardName))
            images[cardIndex+1] = cards[cardIndex]?.image
            newCards.append(Card2(id: cardIndex+1, deck: deck.id!, name: cards[cardIndex]?.cardName, order: cardIndex, attributes: nil, image: nil))
        }
        
        let upload = UploadUtil(delegate: self, deck: deck, cards: newCardsSimple, cardsArray: newCards, cardAttributes: newCardAttributes, images: images)
    }
    
    func takeOrSelectImage() {
        let actionSheet = UIAlertController(title: "Bild hinzufügen", message: "Wähle eine Bildquelle aus.", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            self.checkCameraOrPhotosAccessStatus(.camera, andThen: self.openCamera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            self.checkCameraOrPhotosAccessStatus(.photoLibrary, andThen: self.openPhotoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.view?.window?.rootViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func openPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        self.view?.window?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.view?.window?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        DispatchQueue.main.async {
            guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            self.cardNode.didSelectImage(selectedImage)
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func checkCameraOrPhotosAccessStatus(_ source: UIImagePickerControllerSourceType, andThen f:(()->())? = nil) {
        if source == .camera {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                f?()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            f?()
                        }
                    }
                })
            case .restricted:
                // do nothing
                break
            case .denied:
                let alert = UIAlertController(title: "Autorisierung", message: "Erlaube Quartett den Zugriff auf deine Kamera um Bilder neuen Karten hinzuzufügen.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Nicht erlauben", style: .cancel))
                alert.addAction(UIAlertAction(title: "Einstellungen", style: .default) {
                    _ in
                    let url = URL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.shared.open(url)
                    
                })
                self.view?.window?.rootViewController?.present(alert, animated: true)
                break
            }
        } else if source == .photoLibrary {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                f?()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        DispatchQueue.main.async {
                            f?()
                        }
                    }
                })
            case .restricted:
                // do nothing
                break
            case .denied:
                let alert = UIAlertController(title: "Autorisierung", message: "Erlaube Quartett den Zugriff auf deine Photos um Bilder neuen Karten hinzuzufügen.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Nicht erlauben", style: .cancel))
                alert.addAction(UIAlertAction(title: "Einstellungen", style: .default) {
                    _ in
                    let url = URL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.shared.open(url)
                    
                })
                self.view?.window?.rootViewController?.present(alert, animated: true)
                break
            }
        }
    }
}
