//
//  DrawView.swift
//  TouchTracker
//
//  Created by Vo Huy on 5/18/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    // MARK: - Properties
    // A dictionary containing instances of Line
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    
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
    
    // MARK: - Drawing methods
    
    func stroke(_ line: Line) {
        // Create and stroke a path
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        // based on the properties of a given Line
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    // tell the responser one or more touches occured in a view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            // Get location of the touch in view's coordinate system
            let location = touch.location(in: self)
            // assign the current line to the start point
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        // flag the view to be redrawn at the end of the run loop
        setNeedsDisplay()
    }
    
    // tell the responser whn one or more touches associated with an event changed
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
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
