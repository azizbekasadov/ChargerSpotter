//
//  MainTabBarAssembly.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import CPUIKit
import Factory
import CPUtilsKit
import Foundation

final class MainTabBarAssembly: Assembliable {
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func assembly() -> MainTabBarController {
        MainTabBarController(
            viewModel: container.mainTabBarViewModel.resolve()
        )
    }
}

extension Container {
    var stationRepository: Factory<StationRepository> {
        self { @MainActor in
            StationRepository(
                local: StationLocalRepository(
                    storageService: self.storageService.resolve()
                ),
                remote: StationRemoteRepository()
            )
        }
    }
    
    var connectionManager: Factory<Connectionable> {
        self {
            return ConnectionManager.shared
        }
    }
    
    var mainTabBarViewModel: Factory<MainTabViewModel> {
        self { @MainActor in
            MainTabViewModel(container: self)
        }
    }
}
