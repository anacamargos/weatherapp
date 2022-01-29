//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

final class ErrorView: CodedView {

    // MARK: - View Metrics

    private enum ViewMetrics {
        static let errorImageViewSize: CGFloat = 50
    }

    // MARK: - View Components

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.text = "Unable to load\nTry again"
        return label
    }()

    private let reloadButton: UIButton = {
        let button = UIButton()
        button.setImage(.reloadArrow, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    // MARK: - Override Methods

    override func addSubviews() {
        addSubview(errorLabel)
        addSubview(reloadButton)
    }

    override func constrainSubviews() {
        constrainErrorLabel()
        constrainReloadButton()
    }

    // MARK: - Private Methods

    private func constrainErrorLabel() {
        reloadButton.anchor(
            top: topAnchor,
            topConstant: 64,
            widthConstant: ViewMetrics.errorImageViewSize,
            heightConstant: ViewMetrics.errorImageViewSize
        )
        reloadButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    private func constrainReloadButton() {
        errorLabel.anchor(
            top: reloadButton.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            topConstant: 16,
            leadingConstant: 16,
            bottomConstant: 64,
            trailingConstant: 16
        )
    }
}

