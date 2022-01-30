//
//  HomeContentView.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

protocol HomeContentViewProtocol: AnyObject {
    func setupWeatherState(_ viewState: Home.Weather.ViewState)
}

final class HomeContentView: CodedView {
    
    // MARK: - Dependencies
    
    private let onTappedErrorViewClosure: () -> Void
    
    // MARK: - View Components
    
    private let weatherView: WeatherView = {
        let weatherView = WeatherView()
        weatherView.isHidden = true
        return weatherView
    }()
    
    private let emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    private let loadingView: CustomLoadingView = {
        let loadingView = CustomLoadingView()
        loadingView.isHidden = true
        return loadingView
    }()
    
    private let errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.isHidden = true
        return errorView
    }()
    
    // MARK: - Initializers

    init(
        frame: CGRect = .zero,
        onTappedErrorViewClosure: @escaping () -> Void
    ) {
        self.onTappedErrorViewClosure = onTappedErrorViewClosure
        super.init(frame: frame)
        configureGestureRecognizer()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods

    override func addSubviews() {
        backgroundColor = .white
        addSubview(weatherView)
        addSubview(emptyView)
        addSubview(errorView)
        addSubview(loadingView)
    }

    override func constrainSubviews() {
        constrainWeatherView()
        constrainEmptyView()
        constrainErrorView()
        constrainLoadingView()
    }
    
    // MARK: - Private Methods
    
    private func constrainWeatherView() {
        weatherView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            leadingConstant: 16,
            trailingConstant: 16
        )
    }
    
    private func constrainEmptyView() {
        emptyView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            topConstant: 32,
            leadingConstant: 16,
            trailingConstant: 16
        )
    }
    
    private func constrainErrorView() {
        errorView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            topConstant: 32,
            leadingConstant: 16,
            trailingConstant: 16
        )
    }
    
    private func constrainLoadingView() {
        loadingView.anchor(
            top: safeTopAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            topConstant: 32,
            leadingConstant: 16,
            trailingConstant: 16
        )
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTappedErrorView))
        errorView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onTappedErrorView() {
        onTappedErrorViewClosure()
    }
}

// MARK: - HomeContentViewProtocol

extension HomeContentView: HomeContentViewProtocol {
    
    func setupWeatherState(_ viewState: Home.Weather.ViewState) {
        switch viewState {
        case let .content(viewData):
            weatherView.isHidden = false
            errorView.isHidden = true
            emptyView.isHidden = true
            loadingView.isHidden = true
            weatherView.setupViewData(viewData)
        case .loading:
            loadingView.isHidden = false
            weatherView.isHidden = true
            errorView.isHidden = true
            emptyView.isHidden = true
            loadingView.startLoading()
        case .empty:
            emptyView.isHidden = false
            weatherView.isHidden = true
            errorView.isHidden = true
            loadingView.isHidden = true
        case .error:
            errorView.isHidden = false
            weatherView.isHidden = true
            emptyView.isHidden = true
            loadingView.isHidden = true
        }
    }
}
