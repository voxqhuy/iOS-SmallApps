//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Vo Huy on 4/24/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    // MARK: Meal Class tests
    
    // Confirm that meal class returns a Meal object when passed valid parameters
    func testMealInitializationSucceeds() {
        let breakfast = Meal.init(name: "Eggs", photo: nil, rating: 0)
        XCTAssertNotNil(breakfast)
        
        let lunch = Meal.init(name: "non", photo: nil, rating: 5)
        XCTAssertNotNil(lunch)
    }
    
    // Confirm that the Meal initializer returns nill when passed a negative rating or an empty name.
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meal.init(name: "negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 2)
        XCTAssertNil(emptyStringMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
    }
}
