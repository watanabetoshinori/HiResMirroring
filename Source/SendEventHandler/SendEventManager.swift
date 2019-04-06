//
//  SendEventManager.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class SendEventManager: NSObject {
    
    private var handlers = [SendEventHandler]()
    
    // MARK: - Initializing a Singleton
    
    static let shared = SendEventManager()
    
    override private init() {
        UIWindow.swizzlingSendEvent()
    }
    
    func register(handler: SendEventHandler) {
        if let _ = handlers.firstIndex(where: { $0 === handler }) {
            return
        }
        
        handlers.append(handler)
    }
    
    func unregister(handler: SendEventHandler) {
        if let index = handlers.firstIndex(where: { $0 === handler }) {
            handlers.remove(at: index)
        }
    }
    
    func handleSendEvent(_ window: UIWindow, _ event: UIEvent) {
        handlers.forEach { (handler) in
            if handler.shouldHandleEvent(window) {
                handler.handleSendEvent(event)
            }
        }
    }
    
}
