//
//  HomeConfiguratorTests.swift
//  WeatherAppTests
//
//  Created by Ana Leticia Camargos on 30/01/22.
//

import XCTest
@testable import WeatherApp

final class HomeConfiguratorTests: XCTestCase {

    func test_configurator_shouldReturnCorrectlyConfiguredInstance() {
        // Given
        let sut = HomeConfigurator()
        trackForMemoryLeaks(sut)

        // When
        let viewController = sut.resolveViewController()
        
        // Then
        guard let interactor = Mirror(reflecting: viewController).firstChild(of: HomeInteractor.self) else {
            XCTFail("Could not find HomeInteractor.")
            return
        }
        
        guard Mirror(reflecting: interactor).firstChild(of: LocationService.self) != nil else {
            XCTFail("Could not find HomeInteractor.")
            return
        }

        XCTAssertTrue(interactor.viewController is HomeViewController)
    }

}
