//
//  HomeModels.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation
import UIKit

enum Home {

    enum Weather {

        enum ViewState {
            case content(ViewData)
            case loading
            case empty
            case error
        }

        struct ViewData {
            let cityName: String
            let image: UIImage
            let temperature: String
            let temperatureDescription: String
        }
    }
}
