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
    
    init(container: Container) {
        self.container = container
    }
    
    func assembly() -> MapViewController {
        let viewController = MapViewController(
            viewModel: container.mapViewModel.resolve()
        )
        
        return viewController
    }
}

extension Container {
    var mapViewModel: Factory<MapViewModel> {
        self { @MainActor in
            MapViewModel(
                stationRepository: self.stationRepository.resolve(),
                locationPublisher: self.locationManager.resolve().locationPublisher
            )
        }
    }
}
