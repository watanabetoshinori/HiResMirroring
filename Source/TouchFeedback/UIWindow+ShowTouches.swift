//
//  UIWindow+ShowTouches.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

extension UIWindow {
    
    var showTouchFeedback: Bool {
        get {
            return TouchFeedbackManager.shared.isFeedbackEnabled(for: self)
        }
        set {
            if newValue == true {
                TouchFeedbackManager.shared.enableFeedback(for: self)
            } else {
                TouchFeedbackManager.shared.disableFeedback(for: self)
            }
        }
    }
    
}
