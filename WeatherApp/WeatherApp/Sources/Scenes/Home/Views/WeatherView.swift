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
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let centerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let temperatureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
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
            top: safeTopAnchor,
            topConstant: 16
        )
        titleLabel.anchorCenterXToSuperview()
    }
    
    private func constrainCenterView() {
        centerView.anchor(
            top: titleLabel.bottomAnchor,
            topConstant: 32
        )
        centerView.anchorCenterXToSuperview()
    }
    
    private func constrainTemperatureImageView() {
        temperatureImageView.anchor(
            leading: centerView.leadingAnchor,
            widthConstant: 48,
            heightConstant: 48
        )
        temperatureImageView.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor).isActive = true
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
    
    // MARK: - Public Methods
    
    func setupViewData(_ viewData: Home.Weather.ViewData) {
        titleLabel.text = viewData.cityName
        temperatureImageView.image = viewData.image
        temperatureLabel.text = viewData.temperature
        descriptionLabel.text = viewData.temperatureDescription
    }
}
