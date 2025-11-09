//
//  ClientAPIServiceTests.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import XCTest

@testable import CPNetworkKit

final class ClientAPIServiceTests: XCTestCase {

    private var session: URLSession!
    private var sut: ClientAPIService!

    override func setUp() {
        super.setUp()
        URLProtocolFake.reset()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolFake.self]
        session = URLSession(configuration: configuration)
        sut = ClientAPIService(session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        URLProtocolFake.reset()
        super.tearDown()
    }

    // MARK: - Helpers

    private struct SampleDTO: Codable, Equatable {
        let id: Int
        let name: String
    }

    private func makeURL(_ path: String = "/ok") -> URL {
        URL(string: "https://data.geo.admin.ch/ch.bfe.ladestellen-elektromobilitaet/data/ch.bfe.ladestellen-elektromobilitaet.json" + path)!
    }

    // MARK: - Tests

    func test_fetch_success_decodesModel() async throws {
        let url = makeURL("/success")
        let model = SampleDTO(id: 42, name: "Station")
        
        let data = try JSONEncoder().encode(model)
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        URLProtocolFake.handlers[url.absoluteString] = { _ in
            .init(response: response, data: data, error: nil)
        }

        // When
        let result: SampleDTO = try await sut.fetch(SampleDTO.self, from: url)

        // Then
        XCTAssertEqual(result, model)
    }

    func test_fetch_nilURL_shouldThrowBadURL() async {
        let url: URL? = nil

        await XCTAssertThrowsErrorAsync(
            try await self.sut
                .fetch(SampleDTO.self, from: url)
        ) { error in
            guard case APIError.badURL? = error as? APIError else {
                return XCTFail("Expected APIError.badURL, got \(error)")
            }
        }
    }

    func test_fetch_nonHTTPURLResponse_throwsUnknownResponse() async {
        let url = makeURL("/non-http")
        let nonHTTP = URLResponse(
            url: url,
            mimeType: "application/json",
            expectedContentLength: 0,
            textEncodingName: nil
        )

        URLProtocolFake.handlers[url.absoluteString] = { _ in
            .init(response: nonHTTP, data: Data(), error: nil)
        }

        await XCTAssertThrowsErrorAsync(
            try await self.sut.fetch(SampleDTO.self, from: url)
        ) { error in
            guard case APIError.unknownResponse? = error as? APIError else {
                return XCTFail("Expected APIError.unknownResponse, got \(error)")
            }
        }
    }

    func test_fetch_badStatusCode_throwsBadResponse_serverIssue() async {
        let url = makeURL("/bad-status") // emulating server issue
        let response = HTTPURLResponse(
            url: url,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil
        )!

        URLProtocolFake.handlers[url.absoluteString] = { _ in
            .init(response: response, data: Data(), error: nil)
        }
        
        await XCTAssertThrowsErrorAsync(
            try await self.sut.fetch(SampleDTO.self, from: url)
        ) { error in
            guard case APIError.badResponse(let code)? = error as? APIError else {
                return XCTFail("Expected APIError.badResponse, got \(error)")
            }
            XCTAssertEqual(code, 503)
        }
    }

    func test_fetch_decodingError_propagatesDecodingError() async {
        let url = makeURL("/decode-fail")
        let invalidJSON = Data(#"{"id":"ewfewf#$@$23qrfWECAFAVCWDSCWECC"}"#.utf8) // some corrupted response data
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        URLProtocolFake.handlers[url.absoluteString] = { _ in
            .init(response: response, data: invalidJSON, error: nil)
        }

        // When / Then
        await XCTAssertThrowsErrorAsync(
            try await self.sut.fetch(SampleDTO.self, from: url)
        ) { error in
            XCTAssertTrue(
                error is DecodingError,
                "Expected DecodingError, got \(type(of: error))"
            )
        }
    }

    func test_fetch_urlSessionError_propagatesURLError() async {
        let url = makeURL("/session-error")
        
        URLProtocolFake.handlers[url.absoluteString] = { _ in
            .init(response: nil, data: nil, error: URLError(.timedOut))
        }

        await XCTAssertThrowsErrorAsync(
            try await self.sut.fetch(SampleDTO.self, from: url)
        ) { error in
            guard let urlError = error as? URLError else {
                return XCTFail("Expected URLError, got \(error)")
            }
            XCTAssertEqual(urlError.code, .timedOut)
        }
    }
}
