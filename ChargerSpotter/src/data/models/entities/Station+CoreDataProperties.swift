//
//  Station+CoreDataProperties.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//
//

public import CoreData
public import Foundation

import CPStorageKit

public typealias StationCoreDataPropertiesSet = NSSet

extension Station {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
    }

    @NSManaged public var evseId: String?
    @NSManaged public var lastUpdate: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var stationId: String?
    @NSManaged public var power: NSSet?
}

extension Station {
    @objc(addPowerObject:)
    @NSManaged public func addToPower(_ value: Power)

    @objc(removePowerObject:)
    @NSManaged public func removeFromPower(_ value: Power)

    @objc(addPower:)
    @NSManaged public func addToPower(_ values: NSSet)

    @objc(removePower:)
    @NSManaged public func removeFromPower(_ values: NSSet)
}

extension Station: Identifiable {}

extension Station: Storagable {}
