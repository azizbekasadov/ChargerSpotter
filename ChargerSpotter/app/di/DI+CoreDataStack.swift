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
    var storageService: Factory<StorageService> {
        self { @MainActor in
            CPCoreDataStorageService.shared
        }
    }
}

