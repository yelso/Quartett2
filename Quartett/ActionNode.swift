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
                if isHighlighted {
                    run(defaultOnTouchAnimation())
                } else {
                    run(defaultOnTouchEndAnimation())
                }
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
    
    func defaultOnTouchAnimation() -> SKAction {
        let scaleAction = SKAction.scale(to: 0.97, duration: 0.15)
        let colorBlendAction = SKAction.colorize(withColorBlendFactor: 0.5, duration: 0.15)
        return SKAction.group([scaleAction, colorBlendAction])
    }
    
    func defaultOnTouchEndAnimation() -> SKAction {
        let scaleAction = SKAction.scale(to: 1.00, duration: 0.15)
        let colorBlendAction = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)
        return SKAction.group([scaleAction, colorBlendAction])
    }
}
