//
//  Utils.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation

struct Utils {
    
    static let shared = Utils()
    
    private init() {}
    
    func fromKelvinToCelsius(_ kel: Double) -> Int {
        return Int(kel - 273.1)
    }
    
    func convertTime(time: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(time))
        return formatDateToTime(date: date)
    }
    
    private func formatDateToTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
}
