//
//  HTTPMethod.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

/// This defines the type of HTTP method used to perform the request.
enum HTTPMethod: String {
    /// Defines the suported types of HTTP methods.
    case get
    case post
    case put
    case patch
    case delete

    /// Returns the name of the method to be used in the request.
    var name: String {
        rawValue.uppercased()
    }
}
