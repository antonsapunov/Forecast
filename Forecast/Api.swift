//
//  Api.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation
import Alamofire

class Api {
    
    static let shared = Api()
    
    private init() {}
    
    private let apiKey = "b7f351a9108c3b39731d828200ce6b99"
    private let baseUrl = "api.openweathermap.org"
    
    func requestCurrentWeather(lat: Double, lon: Double, completionHandler: @escaping (DataResponse<ForecastElement, AFError>) -> Void) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = baseUrl
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appId", value: apiKey)
        ]
        guard let url = components.url else { return }
        AF.request(url)
            .responseDecodable { (response: DataResponse<ForecastElement, AFError>) in
               completionHandler(response)
        }
    }
    
    func requestForecastForFiveDays(lat: Double, lon: Double, completionHandler: @escaping (DataResponse<Forecast, AFError>) -> Void) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = baseUrl
        components.path = "/data/2.5/forecast"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appId", value: apiKey)
        ]
        guard let url = components.url else { return }
        AF.request(url)
            .responseDecodable { (response: DataResponse<Forecast, AFError>) in
               completionHandler(response)
        }
    }
}
