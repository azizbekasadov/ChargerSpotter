//
//  Power+CoreDataProperties.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//
//

public import Foundation
public import CoreData


public typealias PowerCoreDataPropertiesSet = NSSet

extension Power {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Power> {
        return NSFetchRequest<Power>(entityName: "Power")
    }

    @NSManaged public var val: Int32
    @NSManaged public var station: Station?

}

extension Power : Identifiable {

}
