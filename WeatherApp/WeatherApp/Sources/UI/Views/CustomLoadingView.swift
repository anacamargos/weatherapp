//
//  CustomLoadingView.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

final class CustomLoadingView: CodedView {

    // MARK: - View Components

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        return view
    }()

    deinit {
        activityIndicator.stopAnimating()
    }

    // MARK: - Override Methods

    override func addSubviews() {
        addSubview(activityIndicator)
    }

    override func constrainSubviews() {
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.anchor(
            top: topAnchor,
            bottom: bottomAnchor,
            topConstant: 8,
            bottomConstant: 8
        )
    }

    // MARK: - Public Methods

    func startLoading() {
        activityIndicator.startAnimating()
    }
}

