//
//  UniqueStation.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation
import MapKit

class UniqueStation: NSObject {
    let stationId: String
    let maxPower: Int
    let coordinate: CLLocationCoordinate2D
    let lastUpdate: Date?
    let availability: EvseAvailability

    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(stationId)
        return hasher.finalize()
    }

    static func == (lhs: UniqueStation, rhs: UniqueStation) -> Bool {
        return lhs.stationId == rhs.stationId
    }

    init(
        stationId: String,
        maxPower: Int,
        coordinate: CLLocationCoordinate2D,
        lastUpdate: Date?,
        availability: EvseAvailability
    ) {
        self.stationId = stationId
        self.maxPower = maxPower
        self.coordinate = coordinate
        self.lastUpdate = lastUpdate
        self.availability = availability
        super.init()
    }
}

extension UniqueStation: Identifiable {
    var id: String {
        self.stationId
    }
}

// MARK: - MKAnnotation Usage

extension UniqueStation: MKAnnotation {
    var title: String? {
        return stationId
    }

    var subtitle: String? {
        var subtitleChunks = [String]()
        subtitleChunks.append("\(maxPower)kW")

        if let lastUpdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let str = dateFormatter.string(from: lastUpdate)
            subtitleChunks.append("\(stationId) updated on:" + str)
        }

        return subtitleChunks.joined(separator: "; ")
    }
}

extension Dictionary where Key == String, Value == [Station] {
    func uniqueStations(
        for evseAvailability: [String: EvseAvailability]
    ) -> [UniqueStation] {
        self.map { (stationId, evseItems) -> UniqueStation in
            let maxPower = evseItems.flatMap { evse -> [Int] in
                guard let powerSet = evse.power as? Set<Power> else { return [] }
                return powerSet.map { Int($0.val) }
            }.max() ?? 0

            let isAvailable = evseItems.contains { evseItem in
                guard let evseId = evseItem.evseId else { return false }
                return evseAvailability[evseId] == .available
            }

            let isOccupied = evseItems.allSatisfy { evseItem in
                guard let evseId = evseItem.evseId else { return false }
                return evseAvailability[evseId] == .occupied
            }

            let isOutOfService = evseItems.allSatisfy { evseItem in
                guard let evseId = evseItem.evseId else { return false }
                return evseAvailability[evseId] == .outOfService
            }

            let availability: EvseAvailability
            
            if isAvailable {
                availability = .available
            } else if isOccupied {
                availability = .occupied
            } else if isOutOfService {
                availability = .outOfService
            } else {
                availability = .unknown
            }

            return UniqueStation(
                stationId: stationId,
                maxPower: maxPower,
                coordinate: evseItems[0].location.coordinate,
                lastUpdate: evseItems[0].lastUpdate,
                availability: availability
            )
        }
    }
}

enum UniqueStationSortOptions {
    case maxPower
    case `default`
}


extension Collection where Element == UniqueStation {

    func sorted(by option: UniqueStationSortOptions) -> [UniqueStation] {
        switch option {
        case .maxPower:
            return self.sorted(
                by: {
                    $0.maxPower != $1.maxPower ? $0.maxPower > $1.maxPower : false
                }
            )
        case .default:
            return self.sorted(by: { $0.stationId < $1.stationId })
        }
    }
    
}
