//
//  NetworkPath.swift
//  cat-breeds
//
//  Created by Developer on 17/09/24.
//

import Foundation

// Determina um protocol para ser usado de transformação para tipo específico
protocol NetworkRequest<Response> where Response: Decodable {
    associatedtype Response
    var path: String { get }
    var method: HTTPMethod { get }
    var responseType: Response.Type { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
