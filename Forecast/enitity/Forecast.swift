//
//  Forecast.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastElement]
}
