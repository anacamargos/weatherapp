//
//  HomeInteractorTests.swift
//  WeatherAppTests
//
//  Created by Ana Leticia Camargos on 30/01/22.
//

import XCTest
@testable import WeatherApp

final class HomeInteractorTests: XCTestCase {

    func test_onViewDidLoad_whenServiceSucceedsWithValidData_shouldCallCorrectMethodInViewControllerWithCorrectParameters() {
        // Given
        let serviceStub = LocationServiceStub()
        serviceStub.getLocationForecastResultToBeReturned = .success(.mock)
        let viewControllerSpy = HomeViewControllerSpy()
        let sut = makeSUT(service: serviceStub, viewController: viewControllerSpy)
        let expectedViewData = Home.Weather.ViewData(cityName: "Toronto", image: .init(), temperature: "-12.785°C", temperatureDescription: "Clear")
        
        // When
        sut.onViewDidLoad()
        
        // Then
        XCTAssertEqual(String(describing: viewControllerSpy.displayWeatherViewStatePassedStates.count), String(describing: 2))
        XCTAssertEqual(String(describing: viewControllerSpy.displayWeatherViewStatePassedStates[0]), String(describing: Home.Weather.ViewState.loading))
        let secondPassedState = viewControllerSpy.displayWeatherViewStatePassedStates[1]
        var passedViewData: Home.Weather.ViewData?
        if case let .content(viewData) = secondPassedState {
            passedViewData = viewData
        }
        guard let passedViewData = passedViewData else {
            XCTFail("Could not find viewData")
            return
        }
        XCTAssertEqual(String(describing: passedViewData.cityName), String(describing: expectedViewData.cityName))
        XCTAssertEqual(String(describing: passedViewData.temperature), String(describing: expectedViewData.temperature))
        XCTAssertEqual(String(describing: passedViewData.temperatureDescription), String(describing: expectedViewData.temperatureDescription))
        
    }
    
    func test_onViewDidLoad_whenServiceSucceedsWithInvalidData_shouldCallCorrectMethodInViewControllerWithCorrectParameters() {
        // Given
        let serviceStub = LocationServiceStub()
        serviceStub.getLocationForecastResultToBeReturned = .success(.init(consolidatedWeather: [], title: "Toronto", locationType: "City", woeid: -12))
        let viewControllerSpy = HomeViewControllerSpy()
        let sut = makeSUT(service: serviceStub, viewController: viewControllerSpy)
        
        // When
        sut.onViewDidLoad()
        
        // Then
        XCTAssertEqual(String(describing: viewControllerSpy.displayWeatherViewStatePassedStates), String(describing: [Home.Weather.ViewState.loading, .empty]))
    }
    
    func test_onViewDidLoad_whenServiceFails_shouldCallCorrectMethodInViewControllerWithCorrectParameters() {
        // Given
        let serviceStub = LocationServiceStub()
        serviceStub.getLocationForecastResultToBeReturned = .failure(.genericError)
        let viewControllerSpy = HomeViewControllerSpy()
        let sut = makeSUT(service: serviceStub, viewController: viewControllerSpy)
        
        // When
        sut.onViewDidLoad()
        
        // Then
        XCTAssertEqual(String(describing: viewControllerSpy.displayWeatherViewStatePassedStates), String(describing: [Home.Weather.ViewState.loading, .error]))
    }
    
    func test_reloadData_whenServiceFails_shouldCallCorrectMethodInViewControllerWithCorrectParameters() {
        // Given
        let serviceStub = LocationServiceStub()
        serviceStub.getLocationForecastResultToBeReturned = .failure(.genericError)
        let viewControllerSpy = HomeViewControllerSpy()
        let sut = makeSUT(service: serviceStub, viewController: viewControllerSpy)
        
        // When
        sut.reloadData()
        
        // Then
        XCTAssertEqual(String(describing: viewControllerSpy.displayWeatherViewStatePassedStates), String(describing: [Home.Weather.ViewState.loading, .error]))
    }

    // MARK: - Test Helpers

    private func makeSUT(
        service: LocationServiceProvider = LocationServiceDummy(),
        viewController: HomeDisplayLogic = HomeViewControllerDummy(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> HomeInteractor {
        let sut = HomeInteractor(service: service)
        sut.viewController = viewController
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

final class LocationServiceDummy: LocationServiceProvider {
    func getLocationForecast(with id: Int, then handle: @escaping (Result<LocationResponseEntity, LocationServiceError>) -> Void) {}
}

final class LocationServiceStub: LocationServiceProvider {
    var getLocationForecastResultToBeReturned: Result<LocationResponseEntity, LocationServiceError> = .success(.mock)
    
    func getLocationForecast(with id: Int, then handle: @escaping (Result<LocationResponseEntity, LocationServiceError>) -> Void) {
        handle(getLocationForecastResultToBeReturned)
    }
}

extension LocationResponseEntity {
    static var mock: LocationResponseEntity {
        .init(consolidatedWeather: [.mock], title: "Toronto", locationType: "City", woeid: 4118)
    }
}

extension LocationResponseEntity.ConsolidatedWeather {
    static var mock: LocationResponseEntity.ConsolidatedWeather {
        .init(id: 5770096438935552, weatherStateName: "Clear", weatherStateAbbr: "c", windDirectionCompass: "NNW", created: "2022-01-29T16:16:23.660868Z", applicableDate: "2022-01-29", minTemp: -18.225, maxTemp: -10.695, theTemp: -12.785, windSpeed: 6.844691999138365, windDirection: 348.17550226801234, airPressure: 1022.0, humidity: 60, visibility: 17.66744710888412, predictability: 68)
    }
}

final class HomeViewControllerSpy: HomeDisplayLogic {
    
    private(set) var displayWeatherViewStatePassedStates = [Home.Weather.ViewState]()
    
    func displayWeatherViewState(_ viewState: Home.Weather.ViewState) {
        displayWeatherViewStatePassedStates.append(viewState)
    }
}

final class HomeViewControllerDummy: HomeDisplayLogic {
    func displayWeatherViewState(_ viewState: Home.Weather.ViewState) {}
}
