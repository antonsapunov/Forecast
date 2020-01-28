//
//  Weather.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
