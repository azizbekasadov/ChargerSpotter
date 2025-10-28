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
