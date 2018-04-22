//
//  GameState.swift
//  Rock-Paper_Scissors
//
//  Created by Vo Huy on 4/22/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

enum GameState {
    case start, win, lose, draw
    
    var description: String {
        switch self {
        case .win:
            return "You won"
        case .lose:
            return "You lost"
        case .draw:
            return "Tie Game"
        default:
            return "Rock, Paper, or Scissors"
        }
    }
    
}
