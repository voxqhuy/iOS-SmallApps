//
//  ViewController.swift
//  Temperature-Conversion
//
//  Created by Vo Huy on 5/9/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // frame of the UIView
        let  firstFrame = CGRect(x: 160, y: 240, width: 100, height: 150)
        // set the UIView on the fram
        let firstView = UIView(frame: firstFrame)
        // set background
        firstView.backgroundColor = UIColor.blue
        // add a subview, to the view that the controller manages
        view.addSubview(firstView)
    }
}

