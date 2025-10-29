//
//  MapViewControllerAssembly.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

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
        self.stationRepository = stationRepository // we make MainTabViewModel as the main source of truth
    }
    
    func assembly() -> MapViewController {
        let viewController = MapViewController(
            viewModel: MapViewModel(
                stationRepository: stationRepository,
                locationPublisher: container.locationManager.resolve().locationPublisher
            )
        )
        
        return viewController
    }
}
