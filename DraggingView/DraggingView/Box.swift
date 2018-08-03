//
//  Box.swift
//  DraggingView
//
//  Created by Vo Huy on 8/2/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class Box: UIView {

    var lastLocation = CGPoint(x: 0, y: 0)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Box.detectPan(_:)))
        self.gestureRecognizers = [panRecognizer]
        
        let blueValue = CGFloat(arc4random_uniform(256)) / 256
        let greenValue = CGFloat(arc4random_uniform(256)) / 256
        let redValue = CGFloat(arc4random_uniform(256)) / 256
        self.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.superview)
        self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.superview?.bringSubview(toFront: self)
        
        lastLocation = self.center
    }
}
