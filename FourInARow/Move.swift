//
//  Move.swift
//  FourInARow
//
//  Created by Vo Huy on 8/1/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import GameplayKit
class Move: NSObject, GKGameModelUpdate  {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
