//
//  Users.swift
//  DroneMaps
//
//  Created by brazilec22 on 04.04.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.
//

import Foundation

// MARK: - WelcomeElement
struct User: Codable {
    let altitude: Double
    let id: Int
    let positionID: Int
    let username: String
    let locate : [area]
}
struct area : Codable {
    var lat : Double
    var lot : Double
}
