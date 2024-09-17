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
    func request<Response>(_ request: some NetworkRequest<Response>) -> AnyPublisher<Response, Error>
}

final class HTTPClient: NetworkClient {
    let domain = ""
    let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    // Enforce consistent class implementation keeping the compiler fast
    // and keeping a opaque type
    func request<Response>(_ request: some NetworkRequest<Response>) -> AnyPublisher<Response, Error> {
        let urlRequest = URLRequest(url: URL(fileURLWithPath: domain + request.path))

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                let httpResponse = response as? HTTPURLResponse
                guard let httpResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: request.responseType, decoder: JSONDecoder())
            .eraseToAnyPublisher()

    }
}

protocol NetworkSession {
    func dataTaskPublisher(for: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: NetworkSession {}
