//
//  DrawView.swift
//  TouchTracker
//
//  Created by Vo Huy on 5/18/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    // A dictionary containing instances of Line
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    // hold on to the index of a selected line
    var selectedLineIndex: Int? {
        didSet {
            // if there is no selected lines, no menu should be shown
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var longPressRecognizer: UILongPressGestureRecognizer!
    var moveRecognizer: UIPanGestureRecognizer!
    var threeFingerSwipeRecognizer: UISwipeGestureRecognizer!
    
    // change line's width according to the velocity
    var maxRecordedVelocity: CGFloat = CGFloat.leastNormalMagnitude
    var minRecordedVelocity: CGFloat = CGFloat.greatestFiniteMagnitude
    var currentVelocity: CGFloat = 0
    var currentLineWidth: CGFloat {
        let maxLineWidth: CGFloat = 20
        let minLineWidth: CGFloat = 1
        // Faster = thinner
        let lineWidth = ((maxRecordedVelocity - currentVelocity) / (maxRecordedVelocity - minRecordedVelocity)) * (maxLineWidth - minLineWidth) + minLineWidth
        return lineWidth
    }
    
    // MARK: - intializer and serialization
    required init?(coder aDecoder: NSCoder) {
        // calling the superclass decoder
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        // Set the number of taps to be recognized
        doubleTapRecognizer.numberOfTapsRequired = 2
        // delay calling touches began on UIGestureRecognizer's view
        doubleTapRecognizer.delaysTouchesBegan = true
        // Attach a gesture recognizer to it
        addGestureRecognizer(doubleTapRecognizer)
        
        // for one tap
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.singleTap(_:)))
        singleTapRecognizer.delaysTouchesBegan = true
        // wait until the doubleTapRecognizer fails before claiming the single tap
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(singleTapRecognizer)
        
        // long press: select a line
        // when it recognizes transitions from possible to began, and from began to ended, it sends its action message to its target (longpress)
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        threeFingerSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DrawView.swipeForPickingColors(_:)))
        threeFingerSwipeRecognizer.numberOfTouchesRequired = 3
        threeFingerSwipeRecognizer.direction = .up
        addGestureRecognizer(threeFingerSwipeRecognizer)
        
        // recognizer for panning, dragging
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        // give the pan gesture recognizer a delegate. It will call the simultaneous recognition method on its delegate
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        // avoid conflicting with three fingers swipe
        moveRecognizer.require(toFail: threeFingerSwipeRecognizer)
        addGestureRecognizer(moveRecognizer)
        
    }
    
    // MARK: colors
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Gesture Recognizer
    @objc func singleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        // Grab the menu controller
        // The menu that has cut, copy, past, select all, delete
        let menu = UIMenuController.shared
        
        
        if selectedLineIndex != nil {
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
            // Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            // Hide the menu if no line is selected
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
        
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        // no more lines are selected
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        
        // flag the view to redraw
        setNeedsDisplay()
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        // Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        if gestureRecognizer.state == .began  {
            // when the recognizer is in began state (after 0.5s of hold)
            // select the closest line where the gesture occurred
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        } else if gestureRecognizer.state == .ended {
            // when the recognizer is en ended state (the finger is released)
            // deselect the line
            selectedLineIndex = nil
        }
        
        setNeedsDisplay()
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        // update Pan velocity
        updateLineWidth()
        
        // Move the line only when long pressing on a line
        guard longPressRecognizer.state == .changed else {
            return
        }
        // If a line is selected
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position...
            if gestureRecognizer.state == .changed {
                // How far has the pan moved
                let translation = gestureRecognizer.translation(in: self)
                
                // Add the translation to the current beginning and end points of the line
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                // Redraw the screen
                setNeedsDisplay()
            }
        } else {
            // If no line is selected, do not do anything
            return
        }
    }
    
    @objc func swipeForPickingColors(_ gestureRecognizer: UISwipeGestureRecognizer) {
        print("Recognized 3-finger-swipe")
        currentLines.removeAll()
        
        // Grab the menu controller
        let menu = UIMenuController.shared
        
        // Make DrawView the target of menu item action messages
        becomeFirstResponder()
        
        let item1 = UIMenuItem(title: "Black", action: #selector(DrawView.selectColor1(_:)))
        let item2 = UIMenuItem(title: "Blue", action: #selector(DrawView.selectColor2(_:)))
        let item3 = UIMenuItem(title: "Green", action: #selector(DrawView.selectColor3(_:)))
        let item4 = UIMenuItem(title: "Red", action: #selector(DrawView.selectColor4(_:)))
        let item5 = UIMenuItem(title: "Purple", action: #selector(DrawView.selectColor5(_:)))
        menu.menuItems = [item1, item2, item3, item4, item5]
        
        // Tel the menu where it should come from and show it
        let targetRect = CGRect(x: self.frame.midX, y: self.frame.midY, width: 2, height: 2)
        menu.setTargetRect(targetRect, in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Drawing methods
    
    func stroke(_ line: Line) {
        line.lineColor.setStroke()
        // Create and stroke a path
        let path = UIBezierPath()
        path.lineWidth = line.width
        path.lineCapStyle = .round
        // based on the properties of a given Line
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    // tell the responser one or more touches occured in a view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        selectedLineIndex = nil
        
        for touch in touches {
            // Get location of the touch in view's coordinate system
            let location = touch.location(in: self)
            // assign the current line to the start point
            let newLine = Line(begin: location, end: location, width: currentLineWidth, lineColor: currentLineColor)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        // flag the view to be redrawn at the end of the run loop
        setNeedsDisplay()
    }
    
    // tell the responser when one or more touches associated with an event changed
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    // tell the responser when one or more fingers are raised on a view
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                line.width = currentLineWidth
                line.lineColor = currentLineColor
                // move any finished lines into finishedLines array
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    // handle when the application is interrupted by the OS (eg a phone call)
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        // remove any lines in progress
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        finishedLineColor.setStroke()
        for line in finishedLines {
            line.color.setStroke()
            stroke(line)
        }
        
        // If the line(s) is being drawn, do it(them) in red
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            line.color.setStroke()
            stroke(line)
        }
        
        if let index = selectedLineIndex {
            // select stroke's color
            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine)
        }
    }

    // MARK: - Private methods
    func indexOfLine(at point: CGPoint) -> Int? {
        // Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        // If nothing is close enough to the tapped point, then we did not select a line
        return nil
    }
    
    func hideMenuController() {
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
    
    // MARK: - Menu controller
    @objc func selectColor1(_ sender: UIMenuController) {
        currentLineColor = .black
        hideMenuController()
    }
    
    @objc func selectColor2(_ sender: UIMenuController) {
        currentLineColor = .blue
        hideMenuController()
    }
    
    @objc func selectColor3(_ sender: UIMenuController) {
        currentLineColor = .green
        hideMenuController()
    }
    
    @objc func selectColor4(_ sender: UIMenuController) {
        currentLineColor = .red
        hideMenuController()
    }
    
    @objc func selectColor5(_ sender: UIMenuController) {
        currentLineColor = .purple
        hideMenuController()
    }
    
    // MARK: - system functions
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func updateLineWidth() {
        let x = moveRecognizer.velocity(in: self).x
        let y = moveRecognizer.velocity(in: self).y
        currentVelocity = hypot(x, y)
        
        maxRecordedVelocity = max(currentVelocity, maxRecordedVelocity)
        minRecordedVelocity = min(currentVelocity, minRecordedVelocity)
    }
}
