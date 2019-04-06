//
//  TouchFeedbackManager.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class TouchFeedbackManager: NSObject {

    private var feedbacks = [TouchFeedback]()
    
    // MARK: - Initializing a Singleton
    
    static let shared = TouchFeedbackManager()
    
    override private init() {
        
    }
    
    // MARK: - Managing Feedbacks
    
    func isFeedbackEnabled(for window: UIWindow) -> Bool {
        return feedbacks.first(where: { $0.window == window }) != nil
    }
    
    func enableFeedback(for window: UIWindow) {
        if isFeedbackEnabled(for:  window) {
            // Already enabled
            return
        }
        
        let feedback = TouchFeedback(window: window)
        feedbacks.append(feedback)
        
        SendEventManager.shared.register(handler: feedback)
    }
    
    func disableFeedback(for window: UIWindow) {
        if let index = feedbacks.firstIndex(where: { $0.window == window }) {
            let feedback = feedbacks.remove(at: index)
            feedback.views.forEach({ $0.removeFromSuperview() })

            SendEventManager.shared.unregister(handler: feedback)
        }
    }
    
}
