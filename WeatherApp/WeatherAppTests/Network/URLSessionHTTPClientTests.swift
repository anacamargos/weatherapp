//
//  URLSessionHTTPClientTests.swift
//  WeatherAppTests
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import XCTest
@testable import WeatherApp

final class URLSessionHTTPClientTests: XCTestCase {

    func test_get_whenRequestIsInvalid_shouldReturnInvalidBaseURLError() {
        // Given
        let sut = makeSUT()
        let httpRequest = HTTPRequest(baseURL: .string(""), method: .get)
        let expectedError = NetworkError(.internal(.invalidBaseURL))

        // When
        guard let receivedError = resultErrorFor(networkRequest: httpRequest, sut: sut) else {
            XCTFail("Could not find receivedError")
            return
        }

        // Then
        XCTAssertEqual(String(describing: receivedError), String(describing: expectedError))
    }

    func test_get_whenHTTPResponseIsInvalid_shouldReturnInvalidHTTPResponse() {
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.dataTaskResultToBeReturned = (nil, nil, nil)
        let sut = makeSUT(session: urlSessionMock)
        let httpRequest = HTTPRequest(baseURL: .string("http://a-url.com"), method: .get)
        let expectedError = NetworkError(.internal(.invalidHTTPResponse))

        // When
        guard let receivedError = resultErrorFor(networkRequest: httpRequest, sut: sut) else {
            XCTFail("Could not find receivedError")
            return
        }

        // Then
        XCTAssertEqual(String(describing: receivedError), String(describing: expectedError))
    }

    func test_get_whenRequestFails_shouldReturnReceivedError() {
        // Given
        let urlSessionMock = URLSessionMock()
        let nsError = NSError(domain: "", code: 400)
        urlSessionMock.dataTaskResultToBeReturned = (nil, nil, nsError)
        let sut = makeSUT(session: urlSessionMock)
        let httpRequest = HTTPRequest(baseURL: .string("http://a-url.com"), method: .get)
        let expectedError = NetworkError(requestError: .http(400), rawError: nsError)

        // When
        guard let receivedError = resultErrorFor(networkRequest: httpRequest, sut: sut) else {
            XCTFail("Could not find receivedError")
            return
        }

        // Then
        XCTAssertEqual(String(describing: receivedError), String(describing: expectedError))
    }

    func test_get_whenRequestSucceeds_shouldReturnReceivedResponseAndData() {
        // Given
        let urlSessionMock = URLSessionMock()
        // swiftlint:disable:next force_unwrapping
        let anyURL = URL(string: "http:a-url.com")!
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        urlSessionMock.dataTaskResultToBeReturned = (nil, response, nil)
        let sut = makeSUT(session: urlSessionMock)
        let httpRequest = HTTPRequest(baseURL: .string("http://a-url.com"), method: .get)
        let expectedResponse = NetworkResponse(status: .http(200), data: nil)

        // When
        guard let receivedResponse = resultSuccessFor(networkRequest: httpRequest, sut: sut) else {
            XCTFail("Could not find receivedError")
            return
        }

        // Then
        XCTAssertEqual(String(describing: receivedResponse), String(describing: expectedResponse))
    }

    // MARK: - Test Helpers

    private func makeSUT(
        session: URLSessionProvider = URLSessionDummy(),
        configuration: NetworkConfiguration = NetworkConfiguration(urlProvider: URLProviderDummy()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient(session: session, configuration: configuration)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func resultFor(
        request: NetworkRequest,
        sut: URLSessionHTTPClient,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Result<NetworkResponse, NetworkError> {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var receivedResult: Result<NetworkResponse, NetworkError>!
        let exp = expectation(description: "Wait for completion")
        sut.get(from: request) { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }

    private func resultErrorFor(
        networkRequest: NetworkRequest,
        sut: URLSessionHTTPClient,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Error? {
        let result = resultFor(request: networkRequest, sut: sut)
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultSuccessFor(
        networkRequest: NetworkRequest,
        sut: URLSessionHTTPClient,
        file: StaticString = #file,
        line: UInt = #line
    ) -> NetworkResponse? {
        let result = resultFor(request: networkRequest, sut: sut)
        switch result {
        case let .success(response):
            return response
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }
}

final class URLSessionMock: URLSessionProvider {

    // swiftlint:disable:next large_tuple
    var dataTaskResultToBeReturned: (data: Data?, response: URLResponse?, error: Error?) = (nil, nil, nil)
    private(set) var dataTaskPassedRequests = [URLRequest]()

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskPassedRequests.append(request)
        completionHandler(dataTaskResultToBeReturned.data, dataTaskResultToBeReturned.response, dataTaskResultToBeReturned.error)
        return URLSession.shared.dataTask(with: request)
    }
}

final class URLSessionDummy: URLSessionProvider {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return .init()
    }
}

final class URLProviderDummy: URLProvider {
    func getBaseURL(forServiceGroup group: ServiceGroup) -> String { return "" }
}
