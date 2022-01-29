//
//  BaseURL.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

/// Defines a Base URL, which can come from a String or a Service Group
enum BaseURL {
    /// Represents a BaseURL that comes form a string
    case string(String)
    /// Represents a BaseURL that comes from a Service Group
    case serviceGroup(ServiceGroup)
}
