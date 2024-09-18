//
//  NetworkClient.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import Foundation
import Combine

// Especialização através de protocolos
// Garante o pricipio de inversão de depedências
protocol NetworkClient {
    func request<Response>(_ request: some NetworkRequest<Response>) -> AnyPublisher<Response, NetworkError>
}

final class HTTPClient: NetworkClient {
    let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    // Enforce consistent class implementation keeping the compiler fast
    // and keeping a opaque type
    func request<Response>(_ request: some NetworkRequest<Response>) -> AnyPublisher<Response, NetworkError> {
        let domain = Constants.networkMainDomain
        let urlRequest = URLRequest(url: URL(fileURLWithPath: domain + request.path))

        return session.dataTask(for: urlRequest)
            .tryMap { data, response in
                let httpResponse = response as? HTTPURLResponse
                guard let httpResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.badServerResponse
                }
                return data
            }
            .decode(type: request.responseType, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.genericError
                }
            }
            .eraseToAnyPublisher()

    }
}

protocol NetworkSession {
    typealias SessionResponse = URLSession.DataTaskPublisher.Output
    func dataTask(for request: URLRequest) -> AnyPublisher<SessionResponse, URLError>
}

extension URLSession: NetworkSession {
    func dataTask(for request: URLRequest) -> AnyPublisher<SessionResponse, URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

enum NetworkError: Error, Equatable {
    case genericError
    case badServerResponse
}
