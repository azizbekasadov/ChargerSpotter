//
//  MockStationLocalRepository.swift
//  ChargerSpotterTests
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import CoreData
import Foundation
import CPStorageKit

@testable import ChargerSpotter

final class MockStationLocalRepository: StationLocalRepositoryPresentable {
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DB")
        container.loadPersistentStores { _, error in
            if let error = error {
                testLogger.error(.init(stringLiteral: "Unable to load persistent stores: \(error)"))
                fatalError(error.localizedDescription)
            }
        }
        let storeDescription = NSPersistentStoreDescription(
            url: URL(fileURLWithPath: "/dev/null")
        )
        storeDescription.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [storeDescription]
        container.viewContext.mergePolicy = NSMergePolicy.overwrite
        return container
    }()

    private lazy var coreDataStack: CoreDataStack = {
        let stack = CoreDataStack()
        return stack
    }()
    
    
    func stations() async -> [ChargerSpotter.EVStation] {
        return []
    }
    
    func evseStates() async -> [ChargerSpotter.EvseState] {
        return []
    }
    
    func storeStaticStationData(
        _ evseRootData: ChargerSpotter.EVSERoot
    ) async -> [ChargerSpotter.EVStation] {
        return []
    }
    
    func storeDynamicStationData(
        _ evseStatusesRoot: ChargerSpotter.EVSEStatusesRoot
    ) async -> [ChargerSpotter.EvseState] {
        return []
    }
}



