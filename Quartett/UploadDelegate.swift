//
//  UploadDelegate.swift
//  Quartett
//
//  Created by Puja Dialehabady on 07.02.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation

protocol UploadDelegate {
    func didStartUpload(deckId: Int)
    func didFinishUpload(deckId: Int)
    func didCancelUpload(deckId: Int, _ error: String?)
    func updateUploadProgess(deckId: Int, progress: Float)
}
