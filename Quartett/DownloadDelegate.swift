//
//  DownloadDelegate.swift
//  Quartett
//
//  Created by Puja Dialehabady on 23.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation

protocol DownloadDelegate {
    func didStartDownload(deckId: Int, name: String)
    func didFinishDownload(deckId: Int, name: String)
    func didCancelDownload(deckId: Int, name: String, _ error: String?)
    func updateDownloadProgress(deckId: Int, progress: Float)
}
