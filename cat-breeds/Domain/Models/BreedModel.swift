//
//  BreedModel.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

struct BreedModel {
    let id: String
    let name: String
    let image: String

    init(mapping entity: BreedEntity) {
        id = entity.id
        name = entity.name
        image = entity.imageURL
    }
}
