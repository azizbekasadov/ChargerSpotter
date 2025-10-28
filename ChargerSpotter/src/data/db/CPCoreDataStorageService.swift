//
//  CoreDataStorageServiceImpl.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import CPStorageKit

internal import CoreData

final class CPCoreDataStorageService: StorageService {
    
    // MARK: - Private
    
    private let coreDataStack: CoreDataStack

    private func createRequest<T: Storagable>(withResultType type: T.Type) throws -> NSFetchRequest<T> {
        if let name = T.entity().name {
            return NSFetchRequest(entityName: name)
        } else {
            throw CoreDataError.requestCreationFail
        }
    }

    private func fetchAll<T: Storagable>(
        type: T.Type,
        fetchConfiguration: FetchConfiguration? = nil
    ) -> [T]? {
        do {
            let request = try createRequest(withResultType: T.self)
            request.predicate = fetchConfiguration?.predicate
            request.sortDescriptors = fetchConfiguration?.sortDescriptors
            request.fetchLimit ?= fetchConfiguration?.fetchLimit
            request.fetchOffset ?= fetchConfiguration?.fetchOffset
            let result = try coreDataStack.context.fetch(request)
            return result.isEmpty ? nil : result
        } catch {
            return nil
        }
    }
    
    // MARK: - Internal
    
    var context: NSManagedObjectContext {
        return coreDataStack.context
    }
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Write
    
    func write() {
        coreDataStack.save()
    }
    
    // MARK: - Fetch

    func fetchLast<T: Storagable>(type: T.Type) -> T? {
        return fetchAll(type: T.self)?.last
    }

    func fetch<T: Storagable>(type: T.Type) -> [T]? {
        return fetchAll(type: T.self)
    }

    func fetch<T: Storagable>(
        type: T.Type,
        predicate: NSPredicate
    ) -> [T]? {
        let configuration = FetchConfiguration(predicate: predicate)
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }

    func fetch<T: Storagable>(
        type: T.Type,
        sortDescriptors: [NSSortDescriptor]
    ) -> [T]? {
        let configuration = FetchConfiguration(sortDescriptors: sortDescriptors)
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }

    func fetch<T: Storagable>(
        type: T.Type,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]
    ) -> [T]? {
        let configuration = FetchConfiguration(predicate: predicate, sortDescriptors: sortDescriptors)
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }

    func fetch<T: Storagable>(type: T.Type, configuration: FetchConfiguration) -> [T]? {
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }
    
    // MARK: - Remove

    func remove(_ object: Storagable) {
        coreDataStack.context.delete(object)
    }

    func remove<S: Sequence>(_ objects: S) where S.Iterator.Element: Storagable {
        objects.forEach { coreDataStack.context.delete($0) }
    }

    func removeAll<T: Storagable>(type: T.Type) {
        guard let fetchedObjects = fetchAll(type: T.self) else {
            return
        }

        remove(fetchedObjects)
    }

    func removeAll<T: Storagable>(type: T.Type, predicate: NSPredicate) {
        let configuration = FetchConfiguration(predicate: predicate)
        guard let fetchedObjects = fetchAll(type: T.self, fetchConfiguration: configuration) else {
            return
        }

        remove(fetchedObjects)
    }
    
    func removeBatch<T>(type: T.Type) where T : Storagable {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: NSStringFromClass(T.self))
        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coreDataStack.context.execute(batchRequest)
            
            self.write()
        } catch {
            logger.error(.init(stringLiteral: error.localizedDescription))
        }
    }
}
