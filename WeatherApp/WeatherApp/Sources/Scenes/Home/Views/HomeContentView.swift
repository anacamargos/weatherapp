//
//  HomeContentView.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import UIKit

protocol HomeContentViewProtocol: AnyObject {
}

final class HomeContentView: CodedView {
    
    // MARK: - View Components
    
    // MARK: - Initializers

    override init(
        frame: CGRect = .zero
    ) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods

    override func addSubviews() {
        backgroundColor = .white
    }

    override func constrainSubviews() {
    }
}

// MARK: - HomeContentViewProtocol

extension HomeContentView: HomeContentViewProtocol {}
