//
//  NetworkError.swift
//  cat-breeds
//
//  Created by Developer on 18/09/24.
//

enum NetworkError: Error, Equatable {
    case genericError
    case badServerResponse
    case urlMalformed
}
