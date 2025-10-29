//
//  ListViewAssembly.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Factory
import CPUIKit
import CPUtilsKit
import Foundation

final class ListViewAssembly: Assembliable {
    private let container: Container
    private let stationRepository: StationRepository
    
    init(
        container: Container,
        stationRepository: StationRepository
    ) {
        self.container = container
        self.stationRepository = stationRepository
    }
    
    func assembly() -> ListViewController {
        let viewController = ListViewController(
            viewModel:
                ListViewModel(
                    stationRepository: stationRepository,
                    locationPublisher: container.locationManager.resolve().locationPublisher
                )
        )
        
        return viewController
    }
}
