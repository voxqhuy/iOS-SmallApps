//
//  ViewController.swift
//  DraggingView
//
//  Created by Vo Huy on 8/2/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let maxViews = 30
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewBounds = self.view.bounds
        for _ in 0..<maxViews {
            let pointX = CGFloat(arc4random_uniform(UInt32(UInt(viewBounds.width))))
            let pointY = CGFloat(arc4random_uniform(UInt32(UInt(viewBounds.height))))
            
            let newBox = Box(frame: CGRect(x: pointX, y: pointY, width: 50, height: 50))
            self.view.addSubview(newBox)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

