//
//  Data+.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

public import Foundation
internal import Logging

public extension Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom(
            {
                let container = try $0.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                guard let date = self.decodeDate(from: dateString) else {
                    logger.error(.init(stringLiteral: "Unable to parse date string: \(dateString)"))
                    return Date()
                }
                
                return date
            }
        )
        
        return try decoder.decode(T.self, from: self)
    }

    private func decodeDate(from string: String) -> Date? {
        let input = string.replacingOccurrences(of: " ", with: "")
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = iso8601Formatter.date(from: input) {
            logger.info(.init(stringLiteral: "\(#function) - date: \(date)"))
            return date
        }

        iso8601Formatter.formatOptions = [.withInternetDateTime]
        
        if let date = iso8601Formatter.date(from: input) {
            logger.info(.init(stringLiteral: "\(#function) withInternetDateTime - date: \(date)"))
            return date
        }

        // fallback for ISO failure
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return dateFormatter.date(from: input)
    }
}
