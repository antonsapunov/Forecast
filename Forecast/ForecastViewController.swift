//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Anton Sapunov on 1/28/20.
//  Copyright © 2020 Антон Сапунов. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var currentMainWeatherLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var actionIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tomorrowTemperatureHintLabel: UILabel!
    @IBOutlet weak var tomorrowWeatherLabel: UILabel!
    @IBOutlet weak var tomorrowTemperatureLabel: UILabel!
    @IBOutlet weak var twoDaysTemperatureHintLabel: UILabel!
    @IBOutlet weak var twoDaysWeatherLabel: UILabel!
    @IBOutlet weak var twoDaysTemperatureLabel: UILabel!
    @IBOutlet weak var threeDaysTemperatureHintLabel: UILabel!
    @IBOutlet weak var threeDaysWeatherLabel: UILabel!
    @IBOutlet weak var threeDaysTemperatureLabel: UILabel!
    @IBOutlet weak var sunriseHintLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetHintLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var pressureHintLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityHintLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudsHintLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var windHintLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var presenter: ForecastPresenter!
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultTextScheme()
        setDefaultColorScheme()
        presenter = ForecastPresenter()
        presenter.forecastDelegate = self
        containerView.isHidden = true
        actionIndicator.isHidden = false
        actionIndicator.startAnimating()
        if let savedWeather = presenter.getSavedWeather() {
            setCurrentWeather(forecastElement: savedWeather)
        }
        setupLocationManager()
        initPullToRefresh()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setDefaultTextScheme() {
        tomorrowTemperatureHintLabel.text = Constants.tomorrow
        twoDaysTemperatureHintLabel.text = Constants.twoDays
        threeDaysTemperatureHintLabel.text = Constants.threeDays
        sunriseHintLabel.text = Constants.sunrise
        sunsetHintLabel.text = Constants.sunset
        pressureHintLabel.text = Constants.pressure
        humidityHintLabel.text = Constants.humidity
        cloudsHintLabel.text = Constants.clouds
        windHintLabel.text = Constants.wind
    }
    
    private func setDefaultColorScheme() {
        tomorrowTemperatureHintLabel.tintColor = UIColor.white.withAlphaComponent(0.5)
        currentMainWeatherLabel.textColor = .white
        currentTemperatureLabel.textColor = .white
        tomorrowTemperatureHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        tomorrowTemperatureLabel.textColor = .white
        twoDaysTemperatureHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        twoDaysTemperatureLabel.textColor = .white
        threeDaysTemperatureHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        threeDaysTemperatureLabel.textColor = .white
        sunriseHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        sunriseLabel.textColor = .white
        sunsetHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        sunsetLabel.textColor = .white
        pressureHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        pressureLabel.textColor = .white
        humidityHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        humidityLabel.textColor = .white
        cloudsHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        cloudsLabel.textColor = .white
        windHintLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        windLabel.textColor = .white
    }
    
    private func initPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    @objc func didPullToRefresh() {
        refreshControl?.endRefreshing()
        locationManager.requestLocation()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}

extension ForecastViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        presenter.getWeather(
            lat: locations[0].coordinate.latitude,
            lon: locations[0].coordinate.longitude
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        showError()
    }
}

extension ForecastViewController: ForecastDelegate {
    
    func setCurrentWeather(forecastElement: ForecastElement) {
        locationNameLabel.text = forecastElement.name
        currentMainWeatherLabel.text = forecastElement.weather.first?.main
        currentTemperatureLabel.text =
        "\(Utils.shared.fromKelvinToCelsius(forecastElement.main.temp))°С"
        if let sunriseTime = forecastElement.sys?.sunrise {
            sunriseLabel.text = Utils.shared.convertTime(time: sunriseTime)
        }
        if let sunsetTime = forecastElement.sys?.sunset {
            sunsetLabel.text = Utils.shared.convertTime(time: sunsetTime)
        }
        
        pressureLabel.text = "\(forecastElement.main.pressure) mm"
        humidityLabel.text = "\(Int(forecastElement.main.humidity))%"
        cloudsLabel.text = "\(forecastElement.clouds.all)%"
        windLabel.text = "\(forecastElement.wind.speed) m/s"
        containerView.isHidden = false
        actionIndicator.isHidden = true
        actionIndicator.stopAnimating()
    }
    
    func setWeatherForThreeDays(forecastElements: [ForecastElement]) {
        tomorrowWeatherLabel.text = forecastElements[0].weather.first?.main
        tomorrowTemperatureLabel.text = "\(Utils.shared.fromKelvinToCelsius(forecastElements[0].main.temp))°"
        twoDaysWeatherLabel.text = forecastElements[1].weather.first?.main
        twoDaysTemperatureLabel.text =  "\(Utils.shared.fromKelvinToCelsius(forecastElements[1].main.temp))°"
        threeDaysWeatherLabel.text = forecastElements[2].weather.first?.main
        threeDaysTemperatureLabel.text =  "\(Utils.shared.fromKelvinToCelsius(forecastElements[2].main.temp))°"
    }
    
    func showError() {
        let alert = UIAlertController(title: Constants.errorTitle, message: Constants.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default) { _ in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
}
