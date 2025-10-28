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
    
    init(container: Container) {
        self.container = container
    }
    
    func assembly() -> ListViewController {
        let viewController = ListViewController(
            viewModel: container.listViewModel.resolve()
        )
        
        return viewController
    }
}

extension Container {
    var listViewModel: Factory<ListViewModel> {
        self { @MainActor in
            ListViewModel(
                stationRepository: self.stationRepository.resolve(),
                locationPublisher: self.mainTabBarViewModel.resolve().$userLocation
            )
        }
    }
}
