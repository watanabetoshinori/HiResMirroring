//
//  UIScreen+HiResMirroring.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

extension UIScreen {
    
    @objc class var swizzledMainScreen: UIScreen {
        get {
            if let externalWindow = UIApplication.shared.keyWindow?.externalWindow {
                return externalWindow.screen
            }
            return swizzledMainScreen
        }
    }
    
    class func swizzlingMainScreen() {
        let origin = #selector(getter: UIScreen.main)
        let swizzled = #selector(getter: UIScreen.swizzledMainScreen)
        
        guard let `class`: AnyClass = object_getClass(UIScreen.main) else {
            fatalError("Failed to getClass")
        }
        
        guard let originalMethod = class_getClassMethod(`class`, origin),
            let swizzledMethod = class_getClassMethod(`class`, swizzled) else {
                fatalError("Failed to get instance method.")
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
}
