//
//  UIWindow+HandleSendEvent.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

extension UIWindow {
    
    @objc func swizzledSendEvent(_ event: UIEvent) {
        SendEventManager.shared.handleSendEvent(self, event)
        
        swizzledSendEvent(event)
    }
    
    class func swizzlingSendEvent() {
        let origin = #selector(UIWindow.sendEvent(_:))
        let swizzled = #selector(UIWindow.swizzledSendEvent(_:))
        
        guard let `class`: AnyClass = object_getClass(UIWindow()) else {
            fatalError("Failed to getClass")
        }
        
        guard let originalMethod = class_getInstanceMethod(`class`, origin),
            let swizzledMethod = class_getInstanceMethod(`class`, swizzled) else {
                fatalError("Failed to get instance method.")
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
}
