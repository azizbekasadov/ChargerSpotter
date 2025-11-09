//
//  CoreDataStack.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Foundation
import CPStorageKit

public import CoreData

public final class CoreDataStack: NSObject, CoreDataStackPresentable {
    
    // MARK: - Private
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DB")
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        container.viewContext.mergePolicy = NSMergePolicy.overwrite
        
        container.loadPersistentStores { _, error in
            if let error = error {
                logger.error(.init(stringLiteral: "Unable to load persistent stores: \(error)"))
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    // MARK: - Public
    
    public static let shared: CoreDataStackPresentable = CoreDataStack()
    
    public lazy var context = container.viewContext
    
    public override init() {
        super.init()
    }
    
    public func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            debugPrint("Unable to save context: \(error)")
            fatalError(error.localizedDescription)
        }
    }
}
