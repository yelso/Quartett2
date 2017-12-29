//
//  ActionNode.swift
//  Quartett
//
//  Created by Puja Dialehabady on 26.12.17.
//  Copyright © 2017 Mobile Application Lab. All rights reserved.
//

import Foundation
import SpriteKit

class ActionNode: SKSpriteNode {
    
    enum ActionState {
        case selected
        case active
    }
    
    var state = ActionState.active
    
    var action: () -> Void = { print("No action set") }
    var onTouch: () -> Void = { }
    var onTouchEnd: () -> Void = {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .selected
        onTouch()
        print("touches began ")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .selected {
            print("touch ended")
            action()
            onTouchEnd()
        }
        state = .active
        print("touch ended2")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
}
