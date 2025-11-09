//
//  ClientAPIService.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

public import Foundation

public class ClientAPIService: NetworkService {
    private var session: URLSession
    
    public init(
        session: URLSession = .shared,
        useCache: Bool = false
    ) {
        if useCache {
            let urlCache = URLCache(
                memoryCapacity: 50 * 1024 * 1024,
                diskCapacity: 200 * 1024 * 1024,
                diskPath: "ChargerSpotter"
            )
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .useProtocolCachePolicy
            config.urlCache = urlCache
            
            var _session = URLSession(
                configuration: config,
                delegate: session.delegate,
                delegateQueue: session.delegateQueue
            )
            _session.sessionDescription = session.sessionDescription
            self.session = _session
        } else {
            self.session = session
        }
    }
    
    public func fetch<T: Decodable>(from url: URL?) async throws -> T {
        guard let url = url else {
            throw APIError.badURL
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknownResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.badResponse(statusCode: httpResponse.statusCode)
        }
        
        return try data.decoded()
    }
}
