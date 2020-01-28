//
//  MainInfo.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation

struct MainInfo: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let sea_level: Double?
    let grnd_level: Double?
    let humidity: Double
    let temp_kf: Double?
}
