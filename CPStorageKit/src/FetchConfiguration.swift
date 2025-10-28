//
//  FetchConfiguration.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import CoreData

public struct FetchConfiguration {
    public let predicate: NSPredicate?
    public let sortDescriptors: [NSSortDescriptor]?
    public let fetchLimit: Int?
    public let fetchOffset: Int?
    public let relationshipKeyPathsForPrefetching: [String]?

    public init(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        fetchOffset: Int? = nil,
        relationshipKeyPathsForPrefetching: [String]? = nil
    ) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset
        self.relationshipKeyPathsForPrefetching = relationshipKeyPathsForPrefetching
    }
}
