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
    
    init(texture: SKTexture?) {
        super.init(texture: texture, color: UIColor.clear, size: (texture?.size())!)
        self.isUserInteractionEnabled = true
    }
    
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    var action: () -> Void = { print("No action set") }
    var onTouch: () -> Void = { print("no touch set") }
    var onTouchEnd: () -> Void = { print("no touch end set") }
    
    var customAnimationEnabled = false
    
    private var isHighlighted = false {
        didSet {
            // Guard against repeating the same action.
            guard oldValue != isHighlighted else { return }
            
            // Remove any existing animations that may be in progress.
            removeAllActions()
            
            if customAnimationEnabled {
                if isHighlighted {
                    handleTouch()
                } else {
                    handleTouchEnd()
                }
            } else {
                // Create a scale action to make the button look like it is slightly depressed.
                let newScale: CGFloat = isHighlighted ? 0.99 : 1.01
                let scaleAction = SKAction.scale(by: newScale, duration: 0.15)
            
                // Create a color blend action to darken the button slightly when it is depressed.
                let newColorBlendFactor: CGFloat = isHighlighted ? 1.0 : 0.0
                let colorBlendAction = SKAction.colorize(withColorBlendFactor: newColorBlendFactor, duration: 0.15)
            
                // Run the two actions at the same time.
                run(SKAction.group([scaleAction, colorBlendAction]))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isHighlighted && containsTouches(touches: touches) {
            action()
        }
        isHighlighted = false
    }
    
    private func containsTouches(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.") }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
    
    func handleTouch() {
        onTouch()
    }
    
    func handleTouchEnd() {
        onTouchEnd()
    }
}
