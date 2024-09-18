//
//  BreedsListingViewModel.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

import Combine

protocol BreedsListingViewModel {
    var reloadData: PassthroughSubject<Void, Never> { get }
    var breeds: [BreedModel] { get }

    func refreshData()
}

class BreedsListingViewModelImpl: BreedsListingViewModel {
    private var cancellable = Set<AnyCancellable>()

    // Data
    var reloadData: PassthroughSubject<Void, Never> = .init()
    private(set) var breeds: [BreedModel] = [] {
        didSet {
            reloadData.send(() )
        }
    }

    // Injected
    private let fetchBreedsUseCase: FetchBreedsUseCase

    init(fetchBreedsUseCase: FetchBreedsUseCase = FetchBreedsUseCaseImpl()) {
        self.fetchBreedsUseCase = fetchBreedsUseCase
    }

    func refreshData() {
        loadBreeds()
    }

    private func loadBreeds() {
        fetchBreedsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    print("handle error")
                default:
                    break
                }
            }, receiveValue: { [weak self] in
                self?.breeds = $0
            }).store(in: &cancellable)
    }
}
