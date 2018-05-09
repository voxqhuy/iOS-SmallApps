//
//  ViewController.swift
//  Simple-Quiz-App
//
//  Created by Vo Huy on 5/9/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    // MARK: Properties
    // An array holding questions
    let questions: [String] = [
        "What is 7 + 7?",
        "What is the capitak if Vermont?",
        "What is cognac made from?"
    ]
    
    // An array holding answers
    let answers: [String] = [
        "14",
        "Montpelier",
        "Grapes"
    ]
    
    // the current question index
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
    
    // MARK: Private methods
    @IBAction func showNextQuestion(_ sender: UIButton) {
        // reset question back to the first one when it is the end of the question bank, else keep moving on
        currentQuestionIndex = (currentQuestionIndex == questions.count - 1) ? 0 : (currentQuestionIndex + 1)
        
        let question = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer = answers[currentQuestionIndex]
        answerLabel.text = answer
        
    }
}

