//
//  CoreDataError.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

// MARK: - Private methods

public enum CoreDataError: Error, LocalizedError {
    case requestCreationFail
    
    public var errorDescription: String? {
        switch self {
        case .requestCreationFail:
            return "Request creation failed."
        }
    }
}
