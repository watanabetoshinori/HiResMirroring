//
//  MirroringViewController.swift
//  HiResMirroring
//
//  Created by Watanabe Toshinori on 4/5/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

class MirroringViewController: UIViewController {
    
    @IBOutlet weak var mirroringView: UIView!
    
    @IBOutlet weak var mirroringViewHeight: NSLayoutConstraint!

    @IBOutlet weak var mirroringViewWidth: NSLayoutConstraint!

    private var displayLink: CADisplayLink?
    
    private weak var window: UIWindow?
    
    var rate: CGFloat!

    // MARK: - Instantiate ViewController
    
    class func instantiate(with window: UIWindow) -> MirroringViewController {
        let bundle = Bundle(for: MirroringViewController.self)
        guard let viewController = UIStoryboard(name: "MirroringViewController", bundle: bundle).instantiateInitialViewController() as? MirroringViewController else {
            fatalError("Invalid Storyboard")
        }
        viewController.window = window
        return viewController
    }
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = window?.screen.bounds ?? .zero
        let viewSize = view.bounds

        let rateX = viewSize.width / max(viewSize.width, screenSize.width)
        let rateY = viewSize.height / max(viewSize.height, screenSize.height)
        rate = min(rateX, rateY)
        
        mirroringViewWidth.constant = screenSize.width * rate
        mirroringViewHeight.constant = screenSize.height * rate
        
        mirroringView.layer.borderWidth = 0.5
        mirroringView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Start and Stop Mirroring
    
    func startMirroring() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    func stopMirroring() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    // MARK: - Update
    
    @objc private func update() {
        guard let window = window else {
            return
        }

        mirroringView.subviews.forEach({ $0.removeFromSuperview() })

        let snapshotView = window.screen.snapshotView(afterScreenUpdates: false)
        mirroringView.addSubview(snapshotView)
        
        snapshotView.layer.anchorPoint = .zero
        let scale = rate ?? 1.0
        let xPadding = 1 / scale * -0.5 * snapshotView.bounds.width
        let yPadding = 1 / scale * -0.5 * snapshotView.bounds.height
        snapshotView.transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }

}
