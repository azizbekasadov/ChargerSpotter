//
//  State+CoreDataProperties.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//
//

public import Foundation
public import CoreData

import CPStorageKit

public typealias StateCoreDataPropertiesSet = NSSet

extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var availability: String?
    @NSManaged public var evseId: String?

}

extension State : Identifiable {}

extension State : Storagable {}
