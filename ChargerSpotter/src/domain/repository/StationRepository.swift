//
//  StationRepository.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Combine
import Foundation
import CPUtilsKit
import CoreLocation
import CPStorageKit

internal import CoreData

final class StationRepository {
    
    enum LoadState {
        case `default`
        case loading
        case failed
        case loaded([UniqueStation], Date)
    }

    @Published private(set) var loadState: LoadState = .default

    private var remote: StationRemoteRepositoryPresentable
    private var local: StationLocalRepositoryPresentable
    
    var stationsPublisher: AnyPublisher<([UniqueStation], Date), Never> {
        $loadState
            .compactMap {
                if case let .loaded(stations, date) = $0 {
                    return (stations, Date())
                }
                
                return nil
            }
            .eraseToAnyPublisher()
    }

    init(
        local: StationLocalRepositoryPresentable,
        remote: StationRemoteRepositoryPresentable
    ) {
        self.local = local
        self.remote = remote
    }

    func fetchStations() {
        Task { [weak self] in
            guard let self else { return }
            loadState = .loading
            
            var cachedStations = await local.stations()
            
            if cachedStations.isEmpty {
                do {
                    let staticData: EVSERoot = try await remote.fetchStaticData()
                    logger.info(.init(stringLiteral: "Fetching static station data has finished"))
                    
                    cachedStations = await local.storeStaticStationData(staticData)
                } catch {
                    logger.error(.init(stringLiteral: "Failure occured during fetching stations: \(error.localizedDescription)"))
                    loadState = .failed
                }
            }

            // fallback case
            do {
                let dynamicData = try await remote.fetchDynamicData()
                logger.info(.init(stringLiteral: "Fetching dynamic station data has finished"))
                let evseStates = await local.storeDynamicStationData(dynamicData)
                
                updateLoadState(cachedStations, evseStates: evseStates)
            } catch {
                logger.error(.init(stringLiteral: "Failure occured during fetching dynamic data: \(error.localizedDescription)"))
            }
        }
    }

    // For the case user is offline
    func loadCachedData() {
        Task { [weak self] in
            guard let self else { return }
            let cachedStations = await local.stations()
            guard !cachedStations.isEmpty else {
                return
            }

            let evseStates = await local.evseStates()
            updateLoadState(cachedStations, evseStates: evseStates)
        }
    }

    private func updateLoadState(_ stations: [EVStation], evseStates: [EvseState]) {
        // Preprocess => perfomance
        var evseAvailability: [String: EvseAvailability] = [:]
        
        for state in evseStates {
            evseAvailability[state.evseId, default: .unknown] = state.availability
        }

        var groupedStations: [String: [EVStation]] = [:]
        
        for station in stations {
            groupedStations[station.stationId!, default: []].append(station)
        }

        // Process
        let uniqueStations = groupedStations.uniqueStations(
            for: evseAvailability
        )

        loadState = .loaded(uniqueStations, Date())
    }
}
