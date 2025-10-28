//
//  Sequence+.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

internal import Foundation

public extension Sequence {
    subscript<R>(range: R) -> [Element] where R: RangeExpression, R.Bound == Int {
        var result: [Element] = []
        
        for (index, element) in self.enumerated() {
            if range.contains(index) {
                result.append(element)
            }
        }
        return result
    }
}
