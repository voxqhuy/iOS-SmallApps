//
//  Utils.swift
//  NamesToSpaces
//
//  Created by Vo Huy on 6/19/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

struct Utils {
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
