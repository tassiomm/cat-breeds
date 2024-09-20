//
//  FetchBreedsUseCase.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

import Combine

protocol FetchBreedsUseCase {
    func execute() -> AnyPublisher<[BreedModel], any Error>
}

final class FetchBreedsUseCaseImpl: FetchBreedsUseCase {
    @Inject private var service: FetchBreedsService

    func execute() -> AnyPublisher<[BreedModel], any Error> {
        service.execute()
            .map { $0.map(BreedModel.init(mapping:)) }
            .eraseToAnyPublisher()

    }
}
