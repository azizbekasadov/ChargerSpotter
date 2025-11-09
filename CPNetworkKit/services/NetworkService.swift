//
//  NetworkService.swift
//  CPNetworkKit
//
//  Created by Azizbek Asadov on 29.10.2025.
//

public import Foundation

public protocol NetworkService {
    func fetch<T: Decodable>(
        _ type: T.Type,
        url: URL?,
        completion: @escaping(Result<T,APIError>) -> Void
    )
    
    func fetch<T: Decodable>(from url: URL?) async throws -> T
}

public extension NetworkService {
    func fetch<T: Decodable>(
        _ type: T.Type,
        url: URL?,
        completion: @escaping(Result<T,APIError>) -> Void
    ) {}
}
