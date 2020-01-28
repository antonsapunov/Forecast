//
//  ForecastPresenter.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import Foundation

protocol ForecastDelegate: AnyObject {
    func setCurrentWeather(forecastElement: ForecastElement)
    func setWeatherForThreeDays(forecastElements: [ForecastElement])
    func showError()
}

class ForecastPresenter {
    
    weak var forecastDelegate: ForecastDelegate?
    
    private let api = Api.shared
    private let storageKey = "weather"
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func getWeather(lat: Double, lon: Double) {
        getCurrentWeather(lat: lat, lon: lon)
        getWeatherForThreeDays(lat: lat, lon: lon)
    }
    
    private func getCurrentWeather(lat: Double, lon: Double) {
        api.requestCurrentWeather(lat: lat, lon: lon) { [weak self] response in
            if let forecastElement = response.value {
                self?.saveWeather(forecastElement: forecastElement)
                self?.forecastDelegate?.setCurrentWeather(forecastElement: forecastElement)
            } else {
                self?.forecastDelegate?.showError()
            }
        }
    }
    
    private func getWeatherForThreeDays(lat: Double, lon: Double) {
        api.requestForecastForFiveDays(lat: lat, lon: lon) { [weak self] response in
            if response.error == nil {
                var dailyForecast = response.value?.list.enumerated().compactMap { tuple in
                        tuple.offset.isMultiple(of: 8) ? tuple.element : nil
                    }
                dailyForecast?.removeFirst()
                dailyForecast?.removeLast()
                if let forecastElements = dailyForecast { self?.forecastDelegate?.setWeatherForThreeDays(forecastElements: forecastElements)
                } else {
                    self?.forecastDelegate?.showError()
                }
            } else {
                self?.forecastDelegate?.showError()
            }
        }
    }
    
    func getSavedWeather() -> ForecastElement? {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return nil }
        return try? decoder.decode(ForecastElement.self, from: data)
    }
    
    private func saveWeather(forecastElement: ForecastElement) {
        guard let data = try? encoder.encode(forecastElement) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
