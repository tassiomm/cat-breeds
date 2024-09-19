//
//  NetworkSession.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

import Foundation
import Combine

protocol NetworkSession {
    typealias SessionResponse = URLSession.DataTaskPublisher.Output
    func dataTask(for request: URLRequest) -> AnyPublisher<SessionResponse, URLError>
    func dataTask(for url: URL) -> AnyPublisher<SessionResponse, URLError>
}

extension URLSession: NetworkSession {
    func dataTask(for request: URLRequest) -> AnyPublisher<SessionResponse, URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }

    func dataTask(for url: URL) -> AnyPublisher<SessionResponse, URLError> {
        dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
}
