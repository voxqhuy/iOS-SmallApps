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
        updateStatus(GameState.start)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var botIconLabel: UILabel!
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    @IBOutlet weak var rockImageBtn: UIButton!
    
    @IBOutlet weak var paperImageBtn: UIButton!
    
    @IBOutlet weak var scissorsImageBtn: UIButton!
    
    @IBOutlet weak var playAgainBtn: UIButton!
    
    @IBAction func playedRock(_ sender: UIButton) {
        
        updateStatus(GameState.)
    }
    
    @IBAction func playedPaper(_ sender: UIButton) {
    }
    
    @IBAction func playedScissors(_ sender: UIButton) {
    }
    
    @IBAction func playAgainTapped(_ sender: UIButton) {
        updateStatus(GameState.start)
    }
    
    func updateStatus(_ gameStatus: GameState) {
        switch gameStatus {
        case .win:
            view.backgroundColor = UIColor.green
        case .draw:
            view.backgroundColor = UIColor.darkGray
        case .lose:
            view.backgroundColor = UIColor.red
        default:
            view.backgroundColor = UIColor.clear
            botIconLabel.text = "🤖"
            playAgainBtn.isEnabled = false
            rockImageBtn.isEnabled = true
            paperImageBtn.isEnabled = true
            scissorsImageBtn.isEnabled = true
        }
        gameStatusLabel.text = gameStatus.description
        
    }
}

