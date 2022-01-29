//
//  DefaultNetworkDispatcher.swift
//  WeatherApp
//
//  Created by Ana Leticia Camargos on 29/01/22.
//

import Foundation

protocol NetworkDispatcher {

    /// Dispatches a request and returns the value as data
    /// - Parameters:
    ///   - request: a request object
    ///   - then: the request result closure
    func dispatch(
        _ request: NetworkRequest,
        then handle: @escaping (Result<NetworkResponse, NetworkError>) -> Void
    )

    /// Dispatches a request and returns the value as the especified type
    /// - Parameters:
    ///   - type: the type of the object you want
    ///   - request: a request object
    ///   - then: the request result closure
    func requestCodable<T: Codable>(
        ofType type: T.Type,
        for request: NetworkRequest,
        then handle: @escaping (Result<T?, NetworkError>) -> Void
    )
}

final class DefaultNetworkDispatcher: NetworkDispatcher {

    // MARK: - Dependencies

    private let httpClient: HTTPClient
    private let responseDecoder: NetworkResponseDecoder

    // MARK: - Initializers

    init(
        httpClient: HTTPClient,
        responseDecoder: NetworkResponseDecoder
    ) {
        self.httpClient = httpClient
        self.responseDecoder = responseDecoder
    }

    // MARK: - NetworkDispatcher

    func dispatch(_ request: NetworkRequest, then handle: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        httpClient.get(from: request) { result in
            handle(result)
        }
    }

    func requestCodable<T>(ofType type: T.Type, for request: NetworkRequest, then handle: @escaping (Result<T?, NetworkError>) -> Void) where T: Decodable, T: Encodable {
        dispatch(request) { [weak self] result in
            self?.responseDecoder.decodeDataRequestResult(result, ofType: type, then: handle)
        }
    }
}
