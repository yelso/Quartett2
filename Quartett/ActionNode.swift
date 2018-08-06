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
    
    var scale: CGFloat = 0.95
    
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
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
        self.initialColor = UIColor.clear
    }
    
    var action: () -> Void = { }
    var onTouch: () -> Void = { }
    var onTouchEnd: () -> Void = { }
    var onTouchEndInside: () -> Void = {  }
    var onReset: () -> Void = { }
    var holdAction: () -> Void = { }
    
    var isHoldButton = false
    var customFeedbackEnabled = false
    var customAnimationEnabled = false
    var isHighlightButton = false
    var isHighlighted = false
    var isStatic = true
    var moved = false
    var loc = CGPoint(x: 0, y: 0)
    var initialColor: UIColor?
    var timer: Timer?
    var timerFired = false
    
    var isTapped = false {
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
        if (isHoldButton) {
            let deleteAction = SKAction.sequence([SKAction.afterDelay(0.5, performAction: SKAction.group([
                SKAction.run({
                    HapticFeedback.defaultFeedback()
                }), SKAction.repeatForever(SKAction.sequence([SKAction.rotate(toAngle: 0.07, duration: 0.1), SKAction.rotate(toAngle: -0.07, duration: 0.1)]))
                ]))])
            run(deleteAction)
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
                DispatchQueue.main.async {
                    self.timerFired = true
                    self.isHighlighted = false
                    self.removeAllActions()
                    self.zRotation = 0
                    self.isTapped = false
                    self.holdAction()
                    self.timerFired = false
                    self.timer = nil
                }
            })
        }
        if !isStatic {
            loc = getLocationInScene(touches)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAllActions()
        zRotation = 0
        if !timerFired {
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            if !isStatic && moved {
                moved = false
            } else {
                if isTapped && containsTouches(touches: touches) {
                    if !customFeedbackEnabled {
                        if isHighlightButton {
                            if !isHighlighted {
                                HapticFeedback.defaultFeedback()
                            }
                        } else {
                            HapticFeedback.lightFeedback()
                        }
                    }
                    isHighlighted = true
                    isTapped = false
                    action()
                } else {
                    isHighlighted = false
                    isTapped = false
                }
            }
        } else {
            timerFired = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isStatic && abs(abs(getLocationInScene(touches).y) - abs(loc.y)) > self.size.height/1.7 {
            removeAllActions()
            zRotation = 0
            if timer != nil {
                timer!.invalidate()
                timer = nil
                timerFired = false
            }
            moved = true
            isHighlighted = false
            isTapped = false
            if parent != nil {
                parent!.touchesMoved(touches, with: event)
            }
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
    
    private func getLocationInScene(_ touches: Set<UITouch>) -> CGPoint {
        guard let scene = scene else { fatalError("Button must be used within a scene.") }
        return touches.first!.location(in: scene)
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
        let scaleAction = SKAction.scale(to: scale, duration: 0.15)
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
    
    func disable() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
        self.alpha = 1.0
    }
}
