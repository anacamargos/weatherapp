//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

final class WeatherView: CodedView {
    
    // MARK: - View Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let centerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let temperatureImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Override Methods

    override func addSubviews() {
        addSubview(titleLabel)
        addSubview(centerView)
        centerView.addSubview(temperatureImageView)
        centerView.addSubview(temperatureLabel)
        addSubview(descriptionLabel)
    }

    override func constrainSubviews() {
        constrainTitleLabel()
        constrainCenterView()
        constrainTemperatureImageView()
        constrainTemperatureLabel()
        constrainDescriptionLabel()
    }
    
    // MARK: - Private Methods
    
    private func constrainTitleLabel() {
        titleLabel.anchor(
            top: topAnchor
        )
        titleLabel.anchorCenterXToSuperview()
    }
    
    private func constrainCenterView() {
        centerView.anchor(
            top: titleLabel.bottomAnchor,
            topConstant: 16
        )
        centerView.anchorCenterXToSuperview()
    }
    
    private func constrainTemperatureImageView() {
        temperatureImageView.anchor(
            top: centerView.topAnchor,
            leading: centerView.leadingAnchor
        )
    }
    
    private func constrainTemperatureLabel() {
        temperatureLabel.anchor(
            top: centerView.topAnchor,
            leading: temperatureImageView.trailingAnchor,
            bottom: centerView.bottomAnchor,
            trailing: centerView.trailingAnchor,
            leadingConstant: 16
        )
    }
    
    private func constrainDescriptionLabel() {
        descriptionLabel.anchor(
            top: centerView.bottomAnchor,
            topConstant: 16
        )
        descriptionLabel.anchorCenterXToSuperview()
    }
}
