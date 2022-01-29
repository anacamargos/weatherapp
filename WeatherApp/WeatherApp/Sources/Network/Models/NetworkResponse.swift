//
//  NetworkResponse.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

/// Constrains the response and the status code.
struct NetworkResponse {

    let status: Status
    let data: Data?

    init(
        status: Status,
        data: Data?
    ) {
        self.status = status
        self.data = data
    }
}
