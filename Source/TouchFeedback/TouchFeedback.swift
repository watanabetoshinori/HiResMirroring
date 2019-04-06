//
//  TouchFeedback.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class TouchFeedback: NSObject, SendEventHandler {
    
    var window: UIWindow!
    
    var views = [TouchFeedbackView]()
    
    // MARK: - Initialzie TouchFeedback
    
    init(window: UIWindow) {
        super.init()
        self.window = window
    }
    
    // MARK: - SendEvent handler
    
    func shouldHandleEvent(_ window: UIWindow) -> Bool {
        return window == self.window
    }
    
    func handleSendEvent(_ event: UIEvent) {
        guard let touches = event.allTouches, touches.isEmpty == false else {
            return
        }
        
        touches.forEach { (touch) in
            switch touch.phase {
            case .began:
                if let view = views.first(where: { $0.touchID == touch.id }) {
                    view.center = touch.location(in: window)

                } else {
                    let view = TouchFeedbackView()
                    view.touchID = touch.id
                    views.append(view)
                    
                    view.center = touch.location(in: window)
                    window.addSubview(view)
                }

            case .moved:
                let view = views.first(where: { $0.touchID == touch.id })
                view?.center = touch.location(in: window)
                
            case .stationary:
                break
                
            case .ended, .cancelled:
                if let index = views.firstIndex(where: { $0.touchID == touch.id }) {
                    let view = views.remove(at: index)
                    view.removeFromSuperview()
                }
            }
        }
    }
    
}
