//
//  ViewController.swift
//  WorldScramble
//
//  Created by Vo Huy on 6/15/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    var words = Words()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = words
        
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                words.allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            words.allWords = ["silkworm"]
        }
        startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    func startGame() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptAnswer))
        words.allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: words.allWords) as! [String]
        title = words.allWords[0]
        words.usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [unowned self, ac] _ in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(answer: String) {
        let loweredAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: loweredAnswer) {
            if isOriginal(word: loweredAnswer) {
                if isReal(word: loweredAnswer) {
                    words.usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            errorTitle = "Error not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        var playingWord = title!.lowercased()
        
        for letter in word {
            if let pos = playingWord.range(of: String(letter)) {
                playingWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !words.usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

