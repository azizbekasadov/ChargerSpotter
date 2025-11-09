//
//  MapViewControllerAssembly.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Combine
import Factory
import CPUIKit
import CPUtilsKit
import Foundation

final class MapViewControllerAssembly: Assembliable {
    private let container: Container
    private let stationRepository: StationRepository
    
    init(
        container: Container,
        stationRepository: StationRepository
    ) {
        self.container = container
        self.stationRepository = stationRepository
    }
    
    func assembly() -> MapViewController {
        let viewController = MapViewController(
            viewModel: MapViewModel(
                stationsStateLoader: stationRepository.$loadState,
                locationPublisher: container.locationManager.resolve().locationPublisher
            )
        )
        
        return viewController
    }
}
