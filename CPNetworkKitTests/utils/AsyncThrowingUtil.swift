//
//  AsyncThrowingUtil.swift
//  CPNetworkKitTests
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import XCTest

// Asked this from ChatGPT
@discardableResult
func XCTAssertThrowsErrorAsync<T>(
    _ expression: @autoclosure @escaping () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath, line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }
) async -> Error? {
    do {
        _ = try await expression()
        XCTFail(message(), file: file, line: line)
        return nil
    } catch {
        errorHandler(error)
        return error
    }
}
