//
//  EvseAvailability.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit

enum EvseAvailability: String {
    case unknown = "Unknown"
    case occupied = "Occupied"
    case outOfService = "OutOfService"
    case available = "Available"
}

extension EvseAvailability {
    var tintColor: UIColor {
        switch self {
        case .unknown:
            return .lightGray
        case .occupied:
            return .systemRed
        case .outOfService:
            return .darkGray
        case .available:
            return .systemGreen
        }
    }
}

extension EvseAvailability {
    /// Initialize from a status string in a tolerant, case-insensitive way.
    /// Falls back to `.unknown` if the value can't be mapped.
    init(from status: String) {
        let normalized = status
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: " ", with: "")
            .lowercased()

        switch normalized {
        case "available":
            self = .available
        case "occupied":
            self = .occupied
        case "outofservice", "outoforder", "inoperative":
            self = .outOfService
        case "unknown", "", "n/a":
            fallthrough
        default:
            self = .unknown
        }
    }
}

struct EvseState {
    let evseId: String
    let availability: EvseAvailability
}

extension EvseState {
    /// Convenience initializer to allow constructing `EvseState` from a raw String availability.
    /// This is useful when decoding/reading from persistence layers that store availability as String.
    init(evseId: String, availability: String) {
        self.evseId = evseId
        self.availability = EvseAvailability(from: availability)
    }
}
