//
//  FileUtils.swift
//  Quartett
//
//  Created by Puja Dialehabady on 17.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//  Based on Saoud M. Rizwan's code:
//  https://medium.com/@sdrzn/swift-4-codable-lets-make-things-even-easier-c793b6cf29e1

import Foundation
import UIKit

class FileUtils {
    
    static func getFilesWith(suffix: String) -> [String] {
        let enumerator = FileManager.default.enumerator(atPath: Bundle.main.bundlePath)
        let filePaths = enumerator?.allObjects as! [String]
        var txtFilePaths = filePaths.filter{$0.contains(suffix)}
        do {
            let enuu = try FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path).filter{$0.contains(suffix)}
            txtFilePaths.append(contentsOf: enuu)
        } catch {
            fatalError(error.localizedDescription)
        }
        return txtFilePaths
    }
   
    static func save<T: Codable>(_ object: T, as name: String) -> Bool {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name, isDirectory: false)
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            return FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
           
        } catch {
            fatalError(error.localizedDescription)
        }
        return false
    }
    
    static func delete(named name: String) -> Bool{
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name, isDirectory: false)
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            // todo
            return false
        }
        return true
    }
    
    static func saveImage(_ data: Data, name: String) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(name + ".jpg")
            if let imgData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0) {
                try imgData.write(to: fileURL, options: .atomic)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    static func loadCardSet(named name: String) -> CardSet? {
        var path = Bundle.main.path(forResource: name, ofType: "json")
        if path == nil {
            path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name + ".json", isDirectory: false).path
        }
        if path != nil {
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            let decoder = JSONDecoder()
            var cardSet: CardSet?
            do {
                try cardSet = decoder.decode(CardSet.self, from: jsonData!)
            } catch let error {
                fatalError(error.localizedDescription)
            }
            
            return cardSet!
        } else {
        }
        return nil
    }
    
    static func loadImage(setName: String, cardId: String, name: String) -> UIImage {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(setName + "_card" + cardId + "_0.jpg").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        } else {
            do {
            let enuu = try FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path).filter{$0.contains(".jpg")}
            for en in enuu {
                print(en)
            }
            } catch {
                
            }
            print(name)
            return UIImage(named: name)!
        }
    }
}

