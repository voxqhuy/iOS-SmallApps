//
//  PetitionAPI.swift
//  Web
//
//  Created by Vo Huy on 6/17/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

struct PetitionAPI {
    
    static let recentURLString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    static let topRatedURLString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
    
    static func fetchPetitions(forURL urlString: String) -> [[String: String]]? {
        if let url = URL(string: urlString) {
            if let data = try? String(contentsOf: url) {
                let json = JSON(parseJSON: data)
                
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    return parse(json: json)
                }
            }
        }
        return nil
    }
}

extension PetitionAPI {
    
    static func parse(json: JSON) -> [[String: String]]? {
        
        var petitions = [[String: String]]()
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let signatureCount = result["signatureCount"].stringValue
            petitions.append(["title": title, "body": body, "signatureCount": signatureCount])
        }
        return petitions
    }
}
