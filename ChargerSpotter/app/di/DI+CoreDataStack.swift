//
//  DI+CoreDataStack.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Factory
import Foundation
import CPStorageKit

internal import CoreData

extension Container {
    var presistentContainer: Factory<NSPersistentContainer> {
        self {
            let container = NSPersistentContainer(name: "DB")
            container.loadPersistentStores { _, error in
                if let error = error {
                    logger.error(.init(stringLiteral: "Unable to load persistent stores: \(error)"))
                    fatalError(error.localizedDescription)
                }
            }
            container.viewContext.mergePolicy = NSMergePolicy.overwrite
            return container
        }
    }
    
    var coreDataStack: Factory<CoreDataStack> {
        self {
            return CoreDataStack(
                persistentContainer: self.presistentContainer.resolve()
            )
        }
    }
}

