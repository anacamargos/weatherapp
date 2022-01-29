//
//  HomeConfigurator.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

final class HomeConfigurator {
    
    // MARK: - Public Methods

    func resolveViewController() -> UIViewController {
        let urlProvider = DefaultURLProvider()
        let networkConfiguration = NetworkConfiguration(urlProvider: urlProvider)
        let responseDecoder = DefaultResponseDecoder()
        let httpClient = URLSessionHTTPClient(session: URLSession.shared, configuration: networkConfiguration)
        let networkDispatcher = DefaultNetworkDispatcher(httpClient: httpClient, responseDecoder: responseDecoder)
        
        let service = LocationService(networkDispatcher: networkDispatcher)
        let interactor = HomeInteractor(service: service)
        let viewController = HomeViewController(interactor: interactor)
        interactor.viewController = viewController
        return viewController
    }
}
