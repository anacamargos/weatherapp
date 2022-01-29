//
//  LocationService.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

enum LocationServiceError: Error {
    case responseParse
    case genericError
}

protocol LocationServiceProvider {
    func getLocationForecast(with id: Int, then handle: @escaping (Result<LocationResponseEntity, LocationServiceError>) -> Void)
}

final class LocationService: LocationServiceProvider {
    
    // MARK: - Dependencies

    private let networkDispatcher: NetworkDispatcher

    // MARK: - Initializers

    init(networkDispatcher: NetworkDispatcher) {
        self.networkDispatcher = networkDispatcher
    }

    // MARK: - LocationServiceProvider
    
    func getLocationForecast(with id: Int, then handle: @escaping (Result<LocationResponseEntity, LocationServiceError>) -> Void) {
        let request = LocationRequest.location(id)
        execute(request: request, then: handle)
    }
    
    // MARK: - Private Methods

    private func execute<T: Codable>(
        request: LocationRequest,
        then handle: @escaping (Result<T, LocationServiceError>) -> Void
    ) {
        networkDispatcher.requestCodable(ofType: T.self, for: request) { result in
            do {
                guard let data = try result.get() else {
                    handle(.failure(.responseParse))
                    return
                }
                handle(.success(data))
            } catch {
                handle(.failure(.genericError))
            }
        }
    }
}

struct LocationResponseEntity: Codable {
    let consolidatedWeather: [ConsolidatedWeather]
    let title, locationType: String
    let woeid: Int
    
    struct ConsolidatedWeather: Codable {
        let id: Int
        let weatherStateName, weatherStateAbbr, windDirectionCompass, created: String
        let applicableDate: String
        let minTemp, maxTemp, theTemp, windSpeed: Double
        let windDirection, airPressure: Double
        let humidity: Int
        let visibility: Double
        let predictability: Int

        enum CodingKeys: String, CodingKey {
            case id
            case weatherStateName = "weather_state_name"
            case weatherStateAbbr = "weather_state_abbr"
            case windDirectionCompass = "wind_direction_compass"
            case created
            case applicableDate = "applicable_date"
            case minTemp = "min_temp"
            case maxTemp = "max_temp"
            case theTemp = "the_temp"
            case windSpeed = "wind_speed"
            case windDirection = "wind_direction"
            case airPressure = "air_pressure"
            case humidity, visibility, predictability
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case woeid
        case locationType = "location_type"
        case consolidatedWeather = "consolidated_weather"
    }
}
