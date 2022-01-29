//
//  EmptyView.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

final class EmptyView: CodedView {

    // MARK: - View Components

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.text = "No data found"
        return label
    }()

    // MARK: - Override Methods

    override func addSubviews() {
        addSubview(emptyLabel)
    }

    override func constrainSubviews() {
        emptyLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            topConstant: 64,
            leadingConstant: 16,
            bottomConstant: 64,
            trailingConstant: 16
        )
    }

    // MARK: - Public Methods

    func setupLabelText(_ text: String) {
        emptyLabel.text = text
    }
}
