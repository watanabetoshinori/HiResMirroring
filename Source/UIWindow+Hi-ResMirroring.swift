//
//  UIWindow+Hi-ResMirroring.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

extension UIWindow {
    
    // MARK: - Property
    
    private struct AssociatedKeys {
        static var externalWindow = "externalWindow"
    }
    
    var externalWindow : UIWindow? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.externalWindow) as? UIWindow
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.externalWindow, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Enable and Siable High-Resolution Mirroring
    
    public func enableHighResolutionMirroring() {
        // Connect
        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification, object: nil, queue: nil) { (notification) in
            let newScreen = notification.object as! UIScreen
            let screenDimensions = newScreen.bounds
            
            let newWindow = UIWindow(frame: screenDimensions)
            newWindow.screen = newScreen
            
            // Set current rootViewController to the External Screen.
            newWindow.rootViewController = self.rootViewController
            
            // Set mirroring viewController to Main Screen.
            let controller = MirroringViewController.instantiate(with: newWindow)
            self.rootViewController = controller
            
            newWindow.isHidden = false
            
            self.externalWindow = newWindow
            
            // Show Touch location
            newWindow.showTouchFeedback = true
            
            // Start transfer toch event from Main Screen to External Screen
            TouchEventTransfer.shared.enabled(source: self, sourceView: controller.mirroringView, target: newWindow, adjustTouchLocation: true)
            
            // Start screen mirroring
            controller.startMirroring()
            
            UIScreen.swizzlingMainScreen()
            UIApplication.swizzlingKeyWindow()
        }
        
        // Disconnect
        NotificationCenter.default.addObserver(forName: UIScreen.didDisconnectNotification, object: nil,  queue: nil) { (notification) in
            UIScreen.swizzlingMainScreen()
            UIApplication.swizzlingKeyWindow()

            // Stop screen mirroring
            if let controller = self.rootViewController as? MirroringViewController {
                controller.stopMirroring()
            }
            
            // Stop transfer touch event
            TouchEventTransfer.shared.disabled()
            
            // Hide Touch location
            self.externalWindow?.showTouchFeedback = false
            
            // Display rootViewController to Main Screen
            self.externalWindow?.rootViewController?.view.removeFromSuperview()
            self.rootViewController = self.externalWindow?.rootViewController
            
            // Remove the window and its contents.
            self.externalWindow = nil
        }
    }

    public func disableHighResolutionMirroring() {
        NotificationCenter.default.removeObserver(self, name: UIScreen.didConnectNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIScreen.didDisconnectNotification, object: nil)
    }
    
}
