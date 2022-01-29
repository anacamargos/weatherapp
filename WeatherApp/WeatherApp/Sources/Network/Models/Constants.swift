//
//  Constants.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

enum Header {

    enum Key {
        static let contentType = "Content-Type"
    }

    enum ContentType {
        static let applicationJSON = "application/json"
        static let applicationJSONCharsetUTF8 = "application/json; charset=UTF-8"
        static let applicationFormURLEncoded = "application/x-www-form-urlencoded"
    }
}
