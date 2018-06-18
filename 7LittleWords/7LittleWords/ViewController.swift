//
//  ViewController.swift
//  7LittleWords
//
//  Created by Vo Huy on 6/18/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    // MARK: Properties
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var attempts = 1
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    // MARK: Outlets
    @IBOutlet var cluesLabel: UILabel!
    @IBOutlet var answersLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var currentAnswer: UITextField!
    
    // MARK: Actions
    @IBAction func submitTapped(_ sender: UIButton) {
        
        if let solutionIndex = solutions.index(of: currentAnswer.text!){
            score += 1
            if score == 7 {
                levelUp()
            } else {
                alertRightAnswer()
                revealAnswer(atIndex: solutionIndex)
            }
            
        } else {
            reShowButtons()
            alertWrongAnswer()
        }
        
        resetStates()
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        reShowButtons()
        resetStates()
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // filter out to get the buttons only
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        
        loadLevel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

// MARK: - Layout
extension ViewController {
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelFilePath) {
                var lines = levelContents.components(separatedBy: "\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
        for btn in letterButtons {
            btn.isEnabled = true
        }
    }
    
    func reShowButtons() {
        for btn in activatedButtons {
            btn.isHidden = false
        }
    }
    
    func revealAnswer(atIndex index: Int) {
        var splitClues = cluesLabel.text!.components(separatedBy: "\n")
        splitClues[index] = "CLEARED"
        cluesLabel.text = splitClues.joined(separator: "\n")
        
        var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
        splitAnswers[index] = currentAnswer.text!
        answersLabel.text = splitAnswers.joined(separator: "\n")
    }
}

// MARK: - User Interaction
extension ViewController {
    
    @objc func letterTapped(btn: UIButton) {
        print(#function)
        if attempts == 5 {
            alertLongWord()
            return
        }
        
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        btn.isHidden = true
        activatedButtons.append(btn)
        
        attempts += 1
    }
}

// MARK: Helper methods
extension ViewController {
    
    func alertRightAnswer() {
        let alertVC = UIAlertController(title: "Congrats!!", message: "Correct answer", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertVC, animated: true)
    }
    
    func alertWrongAnswer() {
        let alertVC = UIAlertController(title: "Oopss!!", message: "Wrong answer", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertVC, animated: true)
    }
    
    func alertLongWord() {
        let alertVC = UIAlertController(title: "Too many letters", message: "You have used too many letters", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertVC, animated: true)
    }
    
    func resetStates() {
        currentAnswer.text = ""
        // TODO: blur out the answer
        activatedButtons.removeAll()
        attempts = 1
    }
    
    func levelUp() {
        let alertVC = UIAlertController(title: "Level up!", message: "Congratulation, you finished all words for this level.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default) {
            action in
            
            self.level += 1
            self.solutions.removeAll(keepingCapacity: true)
            self.loadLevel()
        })
        present(alertVC, animated: true)
    }
}
