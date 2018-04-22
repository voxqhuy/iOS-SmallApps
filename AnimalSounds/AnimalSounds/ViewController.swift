//
//  ViewController.swift
//  AnimalSounds
//
//  Created by Vo Huy on 4/22/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let meowSound = SimpleSound(named: "meow")
    let woofSound = SimpleSound(named: "woof")
    let mooSound = SimpleSound(named: "moo")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var animalSoundLabel: UILabel!
    
    @IBAction func catButtonTapped(_ sender: UIButton) {
        updateSound("Meow!")
        meowSound.play()
    }
    
    @IBAction func dogButtonTapped(_ sender: UIButton) {
        updateSound("Woof!")
        woofSound.play()
    }
    
    @IBAction func cowButtonTapped(_ sender: UIButton) {
        updateSound("Moo!")
        mooSound.play()
    }
    
    func updateSound(_ text: String) {
        animalSoundLabel.text = text
    }
}

