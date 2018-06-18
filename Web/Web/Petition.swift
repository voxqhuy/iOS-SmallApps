//
//  Petition.swift
//  Web
//
//  Created by Vo Huy on 6/17/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

struct Petition {
    
    var title: String
    var body: String
    var signatureCount: String
    
    init(title: String, body: String, signatureCount: String) {
        self.title = title
        self.body = body
        self.signatureCount = signatureCount
    }
}
