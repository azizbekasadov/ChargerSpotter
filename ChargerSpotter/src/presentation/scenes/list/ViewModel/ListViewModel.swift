//
//  ListViewModel.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Combine
import Foundation
import CoreLocation

final class ListViewModel: ObservableObject {
    @Published var stations: [UniqueStation] = []
    
    private let stationsStateLoader: Published<StationRepository.LoadState>.Publisher
    private let locationPublisher: AnyPublisher<CLLocation, Never>
    
    var cancellables = Set<AnyCancellable>()
    
    init(
        stationsStateLoader: Published<StationRepository.LoadState>.Publisher,
        locationPublisher: AnyPublisher<CLLocation, Never>
    ) {
        self.stationsStateLoader = stationsStateLoader
        self.locationPublisher = locationPublisher
        
        setupBindings()
    }
    
    private func setupBindings() {
        stationsStateLoader
            .combineLatest(locationPublisher.compactMap { $0 })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (state, location) in
                self?.handleLoadState(state: state, location: location)
            })
            .store(in: &cancellables)
    }

    private func handleLoadState(
        state: StationRepository.LoadState,
        location: CLLocation
    ) {
        switch state {
        case let .loaded(stations, _):
            logger.info(.init(stringLiteral: NSStringFromClass(Self.self) + "number of stations: \(stations.count); location: \(location)"))
            
            let filteredStations = stations.filter { station in
                let location = CLLocation(
                    latitude: station.coordinate.latitude,
                    longitude: station.coordinate.longitude
                )
                let distance = location.distance(from: location)
                return distance < 1000
            }

            self.stations = filteredStations
        case .failed:
            logger.error(.init(stringLiteral: "Failed to load static data"))
        default: break
        }
    }
}
