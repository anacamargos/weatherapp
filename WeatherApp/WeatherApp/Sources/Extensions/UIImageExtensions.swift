//
//  UIImageExtensions.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

extension UIImage {

    enum Resource: String {
        case reloadArrow = "reload"
    }

    class var reloadArrow: UIImage { UIImage(.reloadArrow)! }

    convenience init?(_ resource: Resource) {
        self.init(
            named: resource.rawValue
        )
    }
}
