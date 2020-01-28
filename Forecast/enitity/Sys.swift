//
//  Sys.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
