//
//  DefaultURLProviderTests.swift
//  WeatherAppTests
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import XCTest
@testable import WeatherApp

final class DefaultURLProviderTests: XCTestCase {

    func test_getBaseURL_shouldReturnCorrectURL() {
        // Given
        let sut = makeSUT()
        let expectedURL = "https://www.metaweather.com/"

        // When
        let receivedURL = sut.getBaseURL(forServiceGroup: .metaWeather)

        // Then
        XCTAssertEqual(expectedURL, receivedURL)
    }

    // MARK: - Test Helpers

    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> DefaultURLProvider {
        let sut = DefaultURLProvider()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
