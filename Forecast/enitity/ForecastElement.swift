//
//  ForecastElement.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation

struct ForecastElement: Codable {
    let dt: Int
    let main: MainInfo
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let sys: Sys?
    let name: String?
    let dt_txt: String?
}
