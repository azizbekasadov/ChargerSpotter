//
//  CoreDataStack.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import CoreData

public protocol CoreDataStackPresentable {
    var context: NSManagedObjectContext { get }
    
    func save()
}

public final class CoreDataStack: NSObject, CoreDataStackPresentable {
    
    // MARK: - Private
    
    private var persistentContainer: NSPersistentContainer!
    
    override init() {
        fatalError("Unable to setup an object of type:\(NSStringFromClass(Self.self))")
    }
    
    // MARK: - Public
    
    public lazy var context = persistentContainer.viewContext

    public init(
        persistentContainer: NSPersistentContainer
    ) {
        super.init()
        self.persistentContainer = persistentContainer
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
