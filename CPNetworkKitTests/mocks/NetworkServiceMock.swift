//
//  NetworkServiceMock.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import Foundation

@testable import CPNetworkKit

class NetworkServiceMock: NetworkService {
    var countFetchCalled: Int = 0
    var countFetchAsyncCalled: Int = 0
    
    var nextResult: Any?
    var nextError: Error?

    func fetch<T: Decodable>(
        _ type: T.Type,
        url: URL?,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        countFetchCalled += 1
        
        if let error = nextError as? APIError {
            completion(.failure(error))
        } else if let value = nextResult as? T {
            completion(.success(value))
        } else {
            completion(.failure(.unknown))
        }
    }

    func fetch<T>(_ type: T.Type, from url: URL?) async throws -> T where T : Decodable {
        countFetchAsyncCalled += 1
        
        if let error = nextError {
            throw error
        }
        
        guard let value = nextResult as? T else {
            throw APIError.unknown
        }
        
        return value
    }
}
