//
//  FetchBreedsService.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import Combine

protocol FetchBreedsService {
    func execute() -> AnyPublisher<[BreedEntity], any Error>
}

final class FetchBreedsServiceImpl: FetchBreedsService {
    @Inject var client: NetworkClient

    func execute() -> AnyPublisher<[BreedEntity], any Error> {
        client.request(FetchBreedsRequest())
            .mapError { ($0 as Error) }
            .eraseToAnyPublisher()
    }
}
