//
//  UIApplication+Hi-ResMirroring.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

extension UIApplication {
    
    @objc var swizzledKeyWindow: UIWindow {
        get {
            if let externalWindow = swizzledKeyWindow.externalWindow {
                return externalWindow
            }
            return swizzledKeyWindow
        }
    }
    
    class func swizzlingKeyWindow() {
        let origin = #selector(getter: UIApplication.shared.keyWindow)
        let swizzled = #selector(getter: UIApplication.shared.swizzledKeyWindow)
        
        guard let `class`: AnyClass = object_getClass(UIApplication.shared) else {
            fatalError("Failed to getClass")
        }
        
        guard let originalMethod = class_getInstanceMethod(`class`, origin),
            let swizzledMethod = class_getInstanceMethod(`class`, swizzled) else {
                fatalError("Failed to get instance method.")
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
