//
//  LocationRequest.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

enum LocationRequest: NetworkRequest {
    
    case location(Int)
    
    var baseURL: BaseURL { .serviceGroup(.metaWeather) }
    
    var path: String? {
        switch self {
        case let .location(id):
            return "api/location/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .location:
            return .get
        }
    }
}
