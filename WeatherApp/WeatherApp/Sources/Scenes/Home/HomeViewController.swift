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
    
    // MARK: - Dependencies

    private let interactor: HomeBusinessLogic
    private let mainDispatchQueue: DispatchQueueType
    
    // MARK: - View Components

    weak var contentView: HomeContentViewProtocol?
    
    // MARK: - Initializers

    init(
        interactor: HomeBusinessLogic,
        mainDispatchQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.interactor = interactor
        self.mainDispatchQueue = mainDispatchQueue
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        interactor.onViewDidLoad()
    }

    override func loadView() {
        view = HomeContentView(onTappedErrorViewClosure: { [weak self] in self?.handleOnTappedErrorViewAction() })
        contentView = view as? HomeContentViewProtocol
    }
    
    // MARK: - Private Methods

    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "WeatherApp"
    }
    
    private func handleOnTappedErrorViewAction() {
        interactor.reloadData()
    }
}

// MARK: - HomeDisplayLogic

extension HomeViewController: HomeDisplayLogic {
    
    func displayWeatherViewState(_ viewState: Home.Weather.ViewState) {
        mainDispatchQueue.async {
            self.contentView?.setupWeatherState(viewState)
        }
    }
}
