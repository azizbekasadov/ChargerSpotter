//
//  Collection+.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

internal import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
