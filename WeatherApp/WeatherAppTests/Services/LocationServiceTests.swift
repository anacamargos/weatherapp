//
//  LocationServiceTests.swift
//  WeatherAppTests
//
//  Created by Ana Leticia Camargos on 30/01/22.
//

import XCTest
@testable import WeatherApp

final class LocationServiceTests: XCTestCase {
    
    func test_getLocationForecast_whenRequestFails_shouldReturnCorrectError() {
        // Given
        let dispatcherMock = NetworkDispatcherMock<LocationResponseEntity>()
        let sut = makeSUT(networkDispatcher: dispatcherMock)
        let errorMock = NetworkError(.internal(.noInternetConnection))
        dispatcherMock.requestCodableResultToBeReturned = .failure(errorMock)
        let expectedError = LocationServiceError.genericError

        // When
        getLocationForecastExpect(sut, toCompleteWith: .failure(expectedError))

        // Then
        XCTAssertEqual(String(describing: dispatcherMock.requestCodablePassedRequests), String(describing: [LocationRequest.location(4118)]))
    }
    
    func test_getLocationForecast_whenRequestSucceeds_butResponseIsInvalid_shouldReturnCorrectError() {
        // Given
        let dispatcherMock = NetworkDispatcherMock<LocationResponseEntity>()
        let sut = makeSUT(networkDispatcher: dispatcherMock)
        dispatcherMock.requestCodableResultToBeReturned = .success(nil)
        let expectedError = LocationServiceError.responseParse

        // When
        getLocationForecastExpect(sut, toCompleteWith: .failure(expectedError))

        // Then
        XCTAssertEqual(String(describing: dispatcherMock.requestCodablePassedRequests), String(describing: [LocationRequest.location(4118)]))
    }
    
    func test_getLocationForecast_whenRequestSucceedsWithValidResponse_shouldReturnCorrectData() {
        // Given
        let dispatcherMock = NetworkDispatcherMock<LocationResponseEntity>()
        let sut = makeSUT(networkDispatcher: dispatcherMock)
        dispatcherMock.requestCodableResultToBeReturned = .success(.mock)
        let expectedResponse = LocationResponseEntity.mock

        // When
        getLocationForecastExpect(sut, toCompleteWith: .success(expectedResponse))

        // Then
        XCTAssertEqual(String(describing: dispatcherMock.requestCodablePassedRequests), String(describing: [LocationRequest.location(4118)]))
    }
    
    // MARK: - Test Helpers

    private func makeSUT(
        networkDispatcher: NetworkDispatcher,
        file: StaticString = #file,
        line: UInt = #line
    ) -> LocationService {
        let sut = LocationService(networkDispatcher: networkDispatcher)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func getLocationForecastExpect(
        _ sut: LocationService,
        toCompleteWith expectedResult: Result<LocationResponseEntity, LocationServiceError>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for completion")
        sut.getLocationForecast(with: 4118) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(String(describing: receivedItems), String(describing: expectedItems), file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

}

final class NetworkDispatcherMock<T: Codable>: NetworkDispatcher {

    var dispatchResultToBeReturned: Result<NetworkResponse, NetworkError> = .success(.init(status: .http(200), data: nil))
    private(set) var dispatchPassedRequests = [NetworkRequest]()

    func dispatch(_ request: NetworkRequest, then handle: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        dispatchPassedRequests.append(request)
        handle(dispatchResultToBeReturned)
    }

    var requestCodableResultToBeReturned: Result<T?, NetworkError> = .success(nil)
    private(set) var requestCodablePassedRequests = [NetworkRequest]()

    func requestCodable<T>(ofType type: T.Type, for request: NetworkRequest, then handle: @escaping (Result<T?, NetworkError>) -> Void) where T: Decodable, T: Encodable {
        requestCodablePassedRequests.append(request)
        switch requestCodableResultToBeReturned {
        case let .failure(error):
            handle(.failure(error))
        case let .success(anyValue):
            var valueToReturn: T?
            if let anyValue = anyValue, let castedValue = anyValue as? T {
                valueToReturn = castedValue
            }
            handle(.success(valueToReturn))
        }
    }
}
