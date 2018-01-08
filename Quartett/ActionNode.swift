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
        self.initialColor = color
    }
    
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.isUserInteractionEnabled = true
        self.initialColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        self.initialColor = UIColor.clear
    }
    
    var action: () -> Void = { print("No action set") }
    var onTouch: () -> Void = { print("no touch set") }
    var onTouchEnd: () -> Void = { print("no touch end set") }
    var onTouchEndInside: () -> Void = { print("no on touch end inside set") }
    var onReset: () -> Void = { print("No on reset set") }
    
    var customAnimationEnabled = false
    var isHighlightButton = false
    var isHighlighted = false
    var initialColor: UIColor?
    
    private var isTapped = false {
        didSet {
            // Guard against repeating the same action.
            guard oldValue != isTapped else { return }
            
            // Remove any existing animations that may be in progress.
            removeAllActions()
            
            if customAnimationEnabled {
                if isTapped {
                    handleTouch()
                } else {
                    if isHighlightButton && isHighlighted {
                        handleTouchEndInside()
                    } else {
                        handleTouchEnd()
                    }
                }
            } else {
                if isTapped {
                    run(defaultOnTouchAnimation())
                } else {
                    if isHighlightButton && isHighlighted {
                        handleTouchEndInside()
                    } else {
                        run(defaultOnTouchEndAnimation())
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTapped = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTapped && containsTouches(touches: touches) {
            isHighlighted = true
            isTapped = false
            action()
        } else {
            isHighlighted = false
            isTapped = false
        }
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
    
    func handleTouchEndInside() {
        onTouchEndInside()
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
    
    func handleReset() {
        onReset()
    }
}
