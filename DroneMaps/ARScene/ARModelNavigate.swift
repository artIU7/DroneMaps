//
//  ARModelNavigate.swift
//  DroneMaps
//
//  Created by  brazilec22 on 01.08.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation

struct Coordinate {
    var lat : Double
    var lon : Double
}
struct Navigate {
    var id : Int
    var pointGPS : [Coordinate]
    var pointAR : [Coordinate]
    init() {
        self.id = 1
        self.pointGPS = []
        self.pointAR = []
    }
}
