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

class FetchBreedsUseCaseImpl: FetchBreedsUseCase {
    let service: FetchBreedsService

    init(service: FetchBreedsService = FetchBreedsServiceImpl()) {
        self.service = service
    }

    func execute() -> AnyPublisher<[BreedModel], any Error> {
        service.execute()
            .map { $0.map(BreedModel.init(mapping:)) }
            .eraseToAnyPublisher()

    }
}
