//
//  ViewController.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    var isStarred = false {
        didSet {
            let image = isStarred ? UIImage(named: "Starred") : UIImage(named: "Star")
            startButton.setImage(image, for: .normal)
        }
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func starTapped(_ sender: Any) {
        isStarred = !isStarred
    }

}
