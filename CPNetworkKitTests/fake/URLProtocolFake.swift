//
//  URLProtocolFake.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import Foundation

class URLProtocolFake: URLProtocol {
    static var handlers: [String: (URLRequest) -> Response] = [:]
    static var defaultHandler: ((URLRequest) -> Response)?

    static func reset() {
        handlers.removeAll()
        defaultHandler = nil
    }

    override func startLoading() {
        let key = request.url?.absoluteString ?? ""
        let handler = URLProtocolFake.handlers[key] ?? URLProtocolFake.defaultHandler

        guard let result = handler?(request) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        if let error = result.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = result.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = result.data {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        NSLog("Stopping loading")
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

}

extension URLProtocolFake {
    struct Response {
        let response: URLResponse?
        let data: Data?
        let error: Error?
    }
}
