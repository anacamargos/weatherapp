//
//  HomeInteractor.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation
import UIKit

protocol HomeBusinessLogic {
    func onViewDidLoad()
}

final class HomeInteractor {
    
    // MARK: - Dependencies

    weak var viewController: HomeDisplayLogic?
    private let service: LocationServiceProvider
    
    // MARK: - Initializer

    init(
        service: LocationServiceProvider
    ) {
        self.service = service
    }
    
    // MARK: - Private Methods

    private func loadLocationForecast() {
        viewController?.displayWeatherViewState(.loading)
        service.getLocationForecast(with: 4118) { [weak self] result in
            switch result {
            case let .success(response):
                if let currentDayForecast = response.consolidatedWeather.first {
                    let temperatureImage = self?.retrieveImage(for: currentDayForecast.weatherStateAbbr) ?? .init()
                    let viewData = Home.Weather.ViewData(cityName: response.title, image: temperatureImage, temperature: "\(currentDayForecast.theTemp)", temperatureDescription: currentDayForecast.weatherStateName)
                    self?.viewController?.displayWeatherViewState(.content(viewData))
                } else {
                    self?.viewController?.displayWeatherViewState(.empty)
                }
            case .failure:
                self?.viewController?.displayWeatherViewState(.error)
            }
        }
    }
    
    private func retrieveImage(for weatherStateAbbreviation: String) -> UIImage? {
        guard
            let url = URL(string: "https://www.metaweather.com/static/img/weather/png/\(weatherStateAbbreviation).png"),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else { return nil }
        return image
    }
}

// MARK: - HomeBusinessLogic

extension HomeInteractor: HomeBusinessLogic {
    
    func onViewDidLoad() {
        loadLocationForecast()
    }
}
