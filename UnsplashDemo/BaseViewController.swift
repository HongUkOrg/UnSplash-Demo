//
//  BaseViewController.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Initializie
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }

    // MARK: Layout Constraints
    private(set) var didSetupConstraints = false

    override func updateViewConstraints() {
        if self.didSetupConstraints == false {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func setupConstraints() {
        // Override point
    }
}
