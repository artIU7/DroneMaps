//
//  CurrentRoute.swift
//  DroneMaps
//
//  Created by  brazilec22 on 04.07.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation

struct CurrentRoute : Codable {
    var longitude, latitude: Double
}
struct fullRoute : Codable {
    var route : [CurrentRoute]
}
