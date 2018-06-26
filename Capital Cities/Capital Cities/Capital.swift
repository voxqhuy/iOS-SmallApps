//
//  Capital.swift
//  Capital Cities
//
//  Created by Vo Huy on 6/25/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
