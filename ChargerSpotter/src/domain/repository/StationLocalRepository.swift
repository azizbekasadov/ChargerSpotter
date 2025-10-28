//
//  StationLocalRepository.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
import CPStorageKit
import CoreLocation

internal import CoreData

protocol StationLocalRepositoryPresentable {
    @MainActor
    func stations() async -> [EVStation]
    
    @MainActor
    func evseStates() async -> [EvseState]
    
    @MainActor
    func storeStaticStationData(_ evseRootData: EVSERoot) async -> [EVStation]
    
    @MainActor
    func storeDynamicStationData(_ evseStatusesRoot: EVSEStatusesRoot) async -> [EvseState]
}

final class StationLocalRepository: StationLocalRepositoryPresentable {
    private let storageService: StorageService
    
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    // Load cached stations
    @MainActor
    func stations() async -> [EVStation] {
        let fetchConfiguration = FetchConfiguration(
            relationshipKeyPathsForPrefetching: ["power"]
        )
        
        return storageService.fetch(
            type: EVStation.self,
            configuration: fetchConfiguration
        ) ?? []
    }
    
    // Load cached availabilities
    @MainActor
    func evseStates() async -> [EvseState] {
        storageService.fetch(
            type: State.self
        )?.compactMap {
            guard
                let evseID = $0.evseId,
                let availability = EvseAvailability(rawValue: ($0.availability ?? ""))
            else { return nil }
            
            return EvseState(evseId: evseID, availability: availability)
        } ?? []
    }
    
    @MainActor
    func storeStaticStationData(_ evseRootData: EVSERoot) async -> [EVStation] {
        let staticStations = await mapEVSEData(evseRootData)
        storageService.write()
        
        return staticStations
    }
    
    @MainActor
    func storeDynamicStationData(_ evseStatusesRoot: EVSEStatusesRoot) async -> [EvseState] {
        let evseStates = evseStatusesRoot.statuses
            .flatMap { $0.statusRecords }
            .map {
                EvseState(
                    evseId: $0.evseId,
                    availability: EvseAvailability(rawValue: $0.status) ?? .unknown
                )
            }
        
        // Delete all existing records
        evseStates.forEach { [weak self] stationState in
            guard let self else { return }
            
            let state = State(context: self.storageService.context)
            state.evseId = stationState.evseId
            state.availability = stationState.availability.rawValue
        }
        
        storageService.removeBatch(type: State.self)
        storageService.write()
        
        return evseStates
    }
    
    private func mapEVSEData(_ root: EVSERoot) async -> [EVStation] {
        let dataRecords = root.evseData.flatMap {
            $0.dataRecords
        }
        
        let stations = dataRecords.compactMap { [weak context = storageService.context] in
            guard let context = context else {
                fatalError("Unnable to acquire managed context")
            }
            
            context.automaticallyMergesChangesFromParent = true
            
            let station = EVStation(context: context)
            station.stationId = $0.stationId
            station.evseId = $0.evseId
            station.lastUpdate = $0.lastUpdate
            station.latitude = $0.coordinates?.latitude ?? 0
            station.longitude = $0.coordinates?.longitude ?? 0
            
            let powerObj = $0.facilities.map { facility in
                let power = Power(context: storageService.context)
                power.val = Int32(facility.power)
                return power
            }
            
            station.power = NSSet(array: powerObj)
            
            return station
        }
        
        return stations
    }
}
