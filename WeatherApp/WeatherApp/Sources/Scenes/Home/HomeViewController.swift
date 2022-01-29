//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayWeatherViewState(_ viewState: Home.Weather.ViewState)
}

final class HomeViewController: UIViewController {
    
    // MARK: - View Components

    weak var contentView: HomeContentViewProtocol?
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }

    override func loadView() {
        view = HomeContentView()
        contentView = view as? HomeContentViewProtocol
    }
    
    // MARK: - Private Methods

    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "WeatherApp"
    }
}

// MARK: - HomeDisplayLogic

extension HomeViewController: HomeDisplayLogic {
    
    func displayWeatherViewState(_ viewState: Home.Weather.ViewState) {
        contentView?.setupWeatherState(viewState)
    }
}
