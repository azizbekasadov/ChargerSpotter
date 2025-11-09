//
//  ClientAPIServiceEndToEndTests.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import XCTest

@testable import CPNetworkKit

final class ClientAPIServiceEndToEndTests: XCTestCase {
    private var session: URLSession!
    private var sut: ClientAPIService!

    struct Envelope<T: Codable>: Codable, Equatable {
        
        let status: String
        let data: T
        
        static func == (
            lhs: ClientAPIServiceEndToEndTests.Envelope<T>,
            rhs: ClientAPIServiceEndToEndTests.Envelope<T>
        ) -> Bool {
            lhs.status == rhs.status
        }
    }
    struct Station: Codable, Equatable {
        let id: Int
        let title: String
    }

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

    func test_endToEnd_success_flow_decodesEnvelope() async throws {
        // Arrange
        let url = URL(string: "https://data.geo.admin.ch/ch.bfe.ladestellen-elektromobilitaet/data/ch.bfe.ladestellen-elektromobilitaet.json")!
        let expected = Envelope(
            status: "OK",
            data: Station(
                id: 1,
                title: "FastCharge #1"
            )
        )
        let data = try JSONEncoder().encode(expected)
        
        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type":"application/json"]
        )!

        URLProtocolFake.handlers[url.absoluteString] = { _ in
            .init(response: httpResponse, data: data, error: nil)
        }

        // Act
        let decoded: Envelope<Station> = try await sut.fetch(Envelope<Station>.self, from: url)

        // Asset
        XCTAssertEqual(decoded, expected)
    }
}
