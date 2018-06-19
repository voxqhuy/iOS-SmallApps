//
//  PetitionAPI.swift
//  Web
//
//  Created by Vo Huy on 6/17/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

enum PetitionError: Error {
    case parsingError
    case statusError
    case urlContentError
    case invalidURLError
}

enum PetitionResult {
    case success([[String:String]])
    case failure(Error)
}

class PetitionAPI {
    
    static let recentURLString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    static let topRatedURLString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
    
    static func fetchPetitions(forURL urlString: String, completion: @escaping (PetitionResult) -> Void) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            [unowned self] in
            
            if let url = URL(string: urlString) {
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        if let petitions = parse(json: json) {
                            completion(.success(petitions))
                        } else {
                            completion(.failure(PetitionError.parsingError))
                        }
                    } else {
                        completion(.failure(PetitionError.statusError))
                    }
                } else {
                    completion(.failure(PetitionError.urlContentError))
                }
            } else {
                completion(.failure(PetitionError.invalidURLError))
            }
//        }
        
        return
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
