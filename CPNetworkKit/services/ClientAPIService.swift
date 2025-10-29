//
//  ClientAPIService.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

public import Foundation

public class ClientAPIService: NetworkService {
    private var session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
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
