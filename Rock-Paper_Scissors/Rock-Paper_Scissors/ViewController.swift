//
//  ViewController.swift
//  Rock-Paper_Scissors
//
//  Created by Vo Huy on 4/22/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var botIconLabel: UIStackView!
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    @IBOutlet weak var rockImageLabel: UIButton!
    
    @IBOutlet weak var paperImageLabel: UIButton!
    
    @IBOutlet weak var scissorsImageLabel: UIButton!
    
    @IBOutlet weak var playAgainLabel: UIButton!
    
    @IBAction func playedRock(_ sender: UIButton) {
    }
    
    @IBAction func playedPaper(_ sender: UIButton) {
    }
    
    @IBAction func playedScissors(_ sender: UIButton) {
    }
    
    @IBAction func playAgainTapped(_ sender: UIButton) {
    }
}

