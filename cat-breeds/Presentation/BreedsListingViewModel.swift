//
//  BreedsListingViewModel.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

import Foundation
import Combine

protocol BreedsListingViewModel {
    var reloadData: PassthroughSubject<Void, Never> { get }
    var errorAlert: PassthroughSubject<String, Never> { get }

    var breeds: [BreedModel] { get }

    func refreshData()
}

final class BreedsListingViewModelImpl: BreedsListingViewModel {
    @Inject private var fetchBreedsUseCase: FetchBreedsUseCase

    private var cancellable = Set<AnyCancellable>()

    // Data
    var reloadData: PassthroughSubject<Void, Never> = .init()
    var errorAlert: PassthroughSubject<String, Never> = .init()

    private(set) var breeds: [BreedModel] = [] {
        didSet {
            reloadData.send(() )
        }
    }

    init() {}

    func refreshData() {
        loadBreeds()
    }

    private func loadBreeds() {
        fetchBreedsUseCase.execute()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorAlert.send(error.localizedDescription)
                default:
                    break
                }
            }, receiveValue: { [weak self] in
                self?.breeds = $0
            }).store(in: &cancellable)
    }
}
