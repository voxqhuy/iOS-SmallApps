//
//  ViewController.swift
//  MemeMaker
//
//  Created by Vo Huy on 4/23/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let topChoices = [
        CaptionOption(emoji: "🕶", caption: "You know what's cool?"),
        CaptionOption(emoji: "😡", caption: "You know what makes me mad?"),
        CaptionOption(emoji: "💕", caption: "You know what I love?")
    ]
    
    let bottomChoices = [
        CaptionOption(emoji: "😾", caption: "Cats wearing hats"),
        CaptionOption(emoji: "🐶", caption: "Dogs carrying logs"),
        CaptionOption(emoji: "🙈", caption: "Monkeys being funky")
    ]

    @IBOutlet weak var topCaptionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var bottomCaptionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var topCaptionLabel: UILabel!
    
    @IBOutlet weak var bottomCaptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setting the segments at launch
        resetSegment()
        // update the caption
        updateCaption()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
    }
    
    func resetSegment() {
        topCaptionSegmentedControl.removeAllSegments()
        for choice in topChoices {
            topCaptionSegmentedControl.insertSegment(withTitle: choice.emoji, at: topChoices.count, animated: false)
        }
        // choose the defaultly selected index
        topCaptionSegmentedControl.selectedSegmentIndex = 0
        
        bottomCaptionSegmentedControl.removeAllSegments()
        for choice in bottomChoices {
            bottomCaptionSegmentedControl.insertSegment(withTitle: choice.emoji, at: bottomChoices.count, animated: false)
        }
        bottomCaptionSegmentedControl.selectedSegmentIndex = 0
    }
    
    func updateCaption() {
        let topIndex = topCaptionSegmentedControl.selectedSegmentIndex
        topCaptionLabel.text = topChoices[topIndex].caption
        
        let bottomIndex = bottomCaptionSegmentedControl.selectedSegmentIndex
        bottomCaptionLabel.text = bottomChoices[bottomIndex].caption
    }
}

