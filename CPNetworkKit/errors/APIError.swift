//
//  APIError.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

public import Foundation

public enum APIError: Error, CustomStringConvertible {
    case badURL
    case unknownResponse
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    public var localizedDescription: String {
        // user feedback
        switch self {
        case .badURL, .parsing, .unknown, .unknownResponse:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        }
    }
    
    public var description: String {
        switch self {
        case .unknown: 
            return "unknown error"
        case .unknownResponse:
            return "Unknown response"
        case .badURL:
            return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing(let error):
            return "parsing error \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        }
    }
}
