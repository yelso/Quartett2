//
//  FileUtils.swift
//  Quartett
//
//  Created by Puja Dialehabady on 17.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation

class FileUtils {
    
    static func filesWithExtension() -> [String] {
        let enumerator = FileManager.default.enumerator(atPath: Bundle.main.bundlePath)
        let filePaths = enumerator?.allObjects as! [String]
        let txtFilePaths = filePaths.filter{$0.contains(".json")}
        return txtFilePaths
    }
}

