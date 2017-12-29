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
    var onTouchGroup: () -> Void = { print("no group touch set")}
    var onTouchEndGroup: () -> Void = { print("no group touch end set")}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        onTouchGroup()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        onTouchEndGroup()
    }
    
    func addToGroup(_ newMember: GroupActionNode) {
        for member in group {
            member.group.append(newMember)
            newMember.group.append(member)
        }
        group.append(newMember)
        newMember.group.append(self)
    }
    
    func setOnTouchGroup(function: @escaping () -> Void) {
        onTouchGroup = function
        for member in group {
            member.onTouchGroup = function
        }
    }
    
    func setOnTouchEndGroup(function: @escaping () -> Void) {
        onTouchEndGroup = function
        for member in group {
            member.onTouchEndGroup = function
        }
    }
    
    
}
