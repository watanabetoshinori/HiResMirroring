//
//  TouchFeedbackView.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class TouchFeedbackView: UIView {

    // MARK: - Public Variables
    
    var touchID: String!
    
    // MARK: - Initializing a View Object
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    convenience init() {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        
        initialize()
    }
    
    private func initialize() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        
        backgroundColor = .gray
    }

    // MARK: - Hit testing in a View

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }

}
