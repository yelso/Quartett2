//
//  CardDelegate.swift
//  Quartett
//
//  Created by Puja Dialehabady on 04.01.18.
//  Copyright © 2018 Mobile Application Lab. All rights reserved.
//

import Foundation

protocol CardDelegate {
    func didSelectProperty(atIndex index: Int)
    func didCloseCardCompareNode()
}
