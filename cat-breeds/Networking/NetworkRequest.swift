//
//  NetworkPath.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import Foundation

protocol NetworkRequest<Response> where Response: Decodable {
    associatedtype Response
    var path: String { get }
    var method: HTTPMethod { get }
    // A resposta da requisição é decodificada por um JSONDecoder para o tipo definido no genérico "Response"
    var responseType: Response.Type { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
