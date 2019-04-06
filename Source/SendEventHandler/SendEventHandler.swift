//
//  SendEventHandler.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

protocol SendEventHandler: class {
    
    func shouldHandleEvent(_ window: UIWindow) -> Bool

    func handleSendEvent(_ event: UIEvent)

}

extension SendEventHandler {

    func shouldHandleEvent(_ window: UIWindow) -> Bool {
        return true
    }
    
    func handleSendEvent(_ event: UIEvent) {
        
    }

}
