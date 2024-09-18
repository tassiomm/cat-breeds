//
//  FetchBreedsRequest.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

struct FetchBreedsRequest: NetworkRequest {
    typealias Response = [BreedEntity]
    var path: String = "/breeds"
    var method: HTTPMethod = .get
    var responseType: Response.Type = [BreedEntity].self
}

struct BreedEntity: Entity {
    let id: String
    let name: String
    let imageURL: String
}
