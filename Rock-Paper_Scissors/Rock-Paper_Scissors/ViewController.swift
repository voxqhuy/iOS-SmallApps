//
//  ViewController.swift
//  Rock-Paper_Scissors
//
//  Created by Vo Huy on 4/22/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var signButtons = [UIButton]()
    
    @IBOutlet weak var botIconLabel: UILabel!
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    @IBOutlet weak var rockImageBtn: UIButton!
    
    @IBOutlet weak var paperImageBtn: UIButton!
    
    @IBOutlet weak var scissorsImageBtn: UIButton!
    
    @IBOutlet weak var playAgainBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signButtons = [rockImageBtn, paperImageBtn, scissorsImageBtn]
        updateStatus(GameState.start)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signTapped(_ sender: UIButton) {
        let senderTag = sender.tag
        print(senderTag)
        let tappedSign = Sign(rawValue: senderTag)
        play(playedSign: tappedSign!, playedBtn: senderTag)
        
    }
    
    @IBAction func playAgainTapped(_ sender: UIButton) {
        updateStatus(GameState.start)
    }
    
    func updateStatus(_ gameStatus: GameState) {
        switch gameStatus {
        case .win:
            view.backgroundColor = UIColor(red: 167.0/255.0, green: 220.0/255.0, blue: 151.0/255.0, alpha: 1)
        case .draw:
            view.backgroundColor = UIColor.yellow
        case .lose:
            view.backgroundColor = UIColor(red: 237.0/255.0, green: 131.0/255.0, blue: 124.0/255.0, alpha: 1)
        default:
            view.backgroundColor = UIColor.lightGray
            botIconLabel.text = "🤖"
            playAgainBtn.isHidden = true
            for button in signButtons {
                button.isHidden = false
                button.isEnabled = true
            }
        }
        gameStatusLabel.text = gameStatus.description
        
    }
    
    func play(playedSign: Sign, playedBtn: Int) {
        for button in signButtons {
            if button != signButtons[playedBtn] {
                button.isHidden = true
            } else {
                button.isEnabled = false
            }
        }
        let botSign = randomSign()
        let gameStatus = playedSign.versus(botSign)
        botIconLabel.text = botSign.emoji
        playAgainBtn.isHidden = false
        updateStatus(gameStatus)
    }
}

