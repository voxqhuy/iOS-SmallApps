//
//  Person.swift
//  NamesToSpaces
//
//  Created by Vo Huy on 6/19/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {

    var name: String
    var image: String
    
//    required init?(coder aDecoder: NSCoder) {
//        name = aDecoder.decodeObject(forKey: "name") as! String
//        image = aDecoder.decodeObject(forKey: "image") as! String
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(image, forKey: "image")
//    }
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    
}
