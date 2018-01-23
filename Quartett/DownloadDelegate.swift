//
//  DownloadDelegate.swift
//  Quartett
//
//  Created by Puja Dialehabady on 23.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation

protocol DownloadDelegate {
    func didStartdownload(deckId: Int)
    func didFinishDownload(deckId: Int)
    func didCancelDownload(deckId: Int)
}
