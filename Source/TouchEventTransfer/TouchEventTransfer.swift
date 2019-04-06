//
//  TouchEventTransfer.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class TouchEventTransfer: NSObject, SendEventHandler {

    private var touchObjects = [String: UITouch]()
    
    private var sourceWindow: UIWindow!

    private var targetWindow: UIWindow!
    
    private var sourceView: UIView?
    
    private var shouldAdjustTouchLocation = false

    private var rate: CGFloat = 0.0

    // MARK: - Initializing a Singleton
    
    static let shared = TouchEventTransfer()
    
    override private init() {
        
    }
    
    func enabled(source: UIWindow, sourceView: UIView? = nil, target: UIWindow, adjustTouchLocation: Bool = false) {
        self.sourceWindow = source
        self.sourceView = sourceView
        self.targetWindow = target
        self.shouldAdjustTouchLocation = adjustTouchLocation
        
        SendEventManager.shared.register(handler: self)
        
        rate = 0.0
    }
    
    func disabled() {
        SendEventManager.shared.unregister(handler: self)
    }
    
    // MARK: - SendEvent Handler
    
    func shouldHandleEvent(_ window: UIWindow) -> Bool {
        return window == sourceWindow
    }
    
    func handleSendEvent(_ event: UIEvent) {
        guard let touches = event.allTouches, touches.isEmpty == false else {
            return
        }

        let touchObjects = touches.map({ touchObject(for: $0) })
        
        UIEvent.send(touches: touchObjects)
    }

    // MARK: - Managing UITouch
    
    private func touchObject(for touch: UITouch) -> UITouch {
        var location = touch.location(in: sourceView ?? sourceWindow)

        if shouldAdjustTouchLocation {
            if rate == 0.0 {
                let width = sourceView?.frame.width ?? sourceWindow.screen.bounds.width
                let height = sourceView?.frame.height ?? sourceWindow.screen.bounds.height
                let rateX = width / max(width, targetWindow.screen.bounds.width)
                let rateY = height / max(height, targetWindow.screen.bounds.height)
                rate = min(rateX, rateY)
            }
            location = CGPoint(x: location.x / rate, y: location.y / rate)
        }

        if let touchObject = touchObjects[touch.id] {
            // Reusing previous UITouch
            touchObject.setLocation(location)
            touchObject.setPhase(touch.phase)
            touchObject.udpateTimestamp()

            switch touch.phase {
            case .ended, .cancelled:
                touchObjects[touch.id] = nil
            default:
                break
            }

            return touchObject

        } else {
            // Creating new UITouch
            let touchObject = UITouch(with: location, in: targetWindow)
            touchObjects[touch.id] = touchObject
            return touchObject
        }
    }

}
