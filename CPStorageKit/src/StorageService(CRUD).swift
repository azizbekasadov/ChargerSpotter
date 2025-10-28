//
//  StorageService.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import CoreData

// MARK: - Fetch

public protocol StorageFetchable {
    func fetchLast<T: Storagable>(type: T.Type) -> T?
    
    func fetch<T: Storagable>(type: T.Type) -> [T]?

    func fetch<T: Storagable>(
        type: T.Type,
        predicate: NSPredicate
    ) -> [T]?

    func fetch<T: Storagable>(
        type: T.Type,
        sortDescriptors: [NSSortDescriptor]
    ) -> [T]?

    func fetch<T: Storagable>(
        type: T.Type,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]
    ) -> [T]?

    func fetch<T: Storagable>(
        type: T.Type,
        configuration: FetchConfiguration
    ) -> [T]?
}

// MARK: - Write

public protocol StorageServiceWritable {
    func write()
}

// MARK: - Remove

public protocol StorageRemovable {
    func remove(_ object: Storagable)

    func remove<S: Sequence>(_ objects: S) where S.Iterator.Element: Storagable

    func removeAll<T: Storagable>(type: T.Type)

    func removeAll<T: Storagable>(
        type: T.Type,
        predicate: NSPredicate
    )
    
    func removeBatch<T: Storagable>(type: T.Type)
}

/// Used for CRUD operations with Storage
public protocol StorageService: StorageRemovable, StorageFetchable, StorageServiceWritable  {
    var context: NSManagedObjectContext { get }
}
