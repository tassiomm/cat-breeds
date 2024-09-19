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

        // MARK: URL ERROR HANDLING
        guard let url = URL(string: domain + request.path) else {
            return Fail(outputType: Response.self, failure: NetworkError.urlMalformed)
                .eraseToAnyPublisher()
        }

        // MARK: TRIGGER REQUEST PUBLISHER
        let urlRequest = URLRequest(url: url)
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


