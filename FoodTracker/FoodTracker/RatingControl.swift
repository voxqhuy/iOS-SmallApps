//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Vo Huy on 4/24/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    
    // MARK: Properties
    private var ratingButtons = [UIButton]()

    var rating = 0
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Private Methods
    
    private func setupButtons() {
        
        for _ in 0..<5 {
            // Create the button
            let button = UIButton()
            button.backgroundColor = UIColor.red
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false // disable automatically generated constraints
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            // Add the button to the stack
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    
    // MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }
}
