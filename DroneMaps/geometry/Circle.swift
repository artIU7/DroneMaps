//
//  Circle.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 26.05.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation
import NMAKit
//
// MARK - class circle
//
class circle {
    //
    // MARK variables&properties
    //
        var id : Int
        var radius : Double
        var centr : NMAGeoCoordinates
    //
    // MARK Initialization
    //
        init(id : Int,radius : Double,centr : NMAGeoCoordinates) {
            self.id = id
            self.radius = radius
            self.centr = centr
        }
}
