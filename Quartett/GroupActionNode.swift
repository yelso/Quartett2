//
//  GroupActionNode.swift
//  Quartett
//
//  Created by Puja Dialehabady on 28.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class GroupActionNode: ActionNode {
    
    var group = [GroupActionNode]()
    var onTouchGroup: () -> Void = { }
    var onTouchEndGroup: () -> Void = { }
    var onTouchEndInsideGroup: () -> Void = { }
    
    override func handleTouch() {
        super.handleTouch()
        onTouchGroup()
    }
    
    override func handleTouchEnd() {
        super.handleTouchEnd()
        onTouchEndGroup()
    }
    
    override func handleTouchEndInside() {
        super.handleTouchEndInside()
        onTouchEndInsideGroup()
    }
    
    func setUpGroup(_ newGroup: [GroupActionNode]) {
        for member in newGroup {
            member.appendToGroup(newGroup)
        }
    }
    
    func appendToGroup(_ newGroup: [GroupActionNode]) {
        group.removeAll()
        for member in newGroup {
            if member != self {
                group.append(member)
            }
        }
    }
}

