//
//  FetchBreedsRequest.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

struct FetchBreedsRequest: NetworkRequest {
    typealias Response = [BreedEntity]
    let path: String = "/breeds"
    let method: HTTPMethod = .get
    let responseType: Response.Type = [BreedEntity].self
}

struct BreedEntity: Entity {
    let id: String
    let name: String
    let imageURL: String
}
