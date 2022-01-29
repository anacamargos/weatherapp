//
//  HTTPBody.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

/// Defines what can be added to the HTTPBody parameter of the request.
enum HTTPBody {
    case data(Data)
    case dictionary([String: Any])
    case json(Any)
}
