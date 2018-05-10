//
//  ViewController.swift
//  Simple-Quiz-App
//
//  Created by Vo Huy on 5/9/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabel: UILabel!
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
        currentQuestionLabel.text = questions[currentQuestionIndex]
        print("did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the question's label initial alpha
        nextQuestionLabel.alpha = 0
        print("will appear")
    }
    
    // MARK: Private methods
    @IBAction func showNextQuestion(_ sender: UIButton) {
        // reset question back to the first one when it is the end of the question bank, else keep moving on
        currentQuestionIndex = (currentQuestionIndex == questions.count - 1) ? 0 : (currentQuestionIndex + 1)
        
        let question = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        let answer = answers[currentQuestionIndex]
        answerLabel.text = answer
        
    }
    
    // A method handles the animations
    func animateLabelTransitions() {
        // Animate the alpha
        UIView.animate(withDuration: 0.5, delay: 0, options: [],
                    animations: {
                        self.currentQuestionLabel.alpha = 0
                        self.nextQuestionLabel.alpha = 1
                    },
                    completion: { _ in
                        swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                    })
        print("animating")
    }
}

