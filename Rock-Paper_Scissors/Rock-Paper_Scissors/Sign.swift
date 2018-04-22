//
//  Sign.swift
//  Rock-Paper_Scissors
//
//  Created by Vo Huy on 4/22/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

enum Sign {
    case rock, paper, scissors
    var emoji: String {
        switch self {
        case .rock:
            return "👊"
        case .paper:
            return "✋"
        case .scissors:
            return "✌️"
        }
    }
}
