//
//  MainTabViewModel.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
import Combine
import Network
import Factory
import CPUIKit
import Foundation
import CPUtilsKit
import CoreLocation

final class MainTabViewModel: NSObject, ObservableObject {
    // MARK: - Private
    
    private var timer: Timer?
    private var connectionManager: Connectionable?
    
    private(set) var container: Container!
    private(set) var stationRepository: StationRepository!
    private(set) var locationManager: LocationManagerPresentable!

    private(set) lazy var lookupViewControllers: [TabBarType: (any Assembliable)] = [
        TabBarType.map: MapViewControllerAssembly(container: self.container),
        TabBarType.list: ListViewAssembly(container: self.container)
    ]
    
    convenience init(container: Container) {
        self.init()
        
        self.container = container
        self.connectionManager = container.connectionManager.resolve()
        self.stationRepository = container.stationRepository.resolve()
        // Init
        
        self.locationManager = container.locationManager.resolve()
        self.connectionManager?.startMonitoring(completion: nil)
        
        self.connectionManager?.onConnectionStatusChanged { [weak self] status in
            logger.info(.init(stringLiteral: "Connectivity status: \(status)"))
            
            switch status {
            case .connected:
                Task { @MainActor [weak self] in
                    self?.startTimer()
                }
            case .disconnected:
                self?.stationRepository.loadCachedData()
                logger.warning(.init(stringLiteral: "Connectivity status: \(status).\nNo network connection"))
                break
            @unknown default:
                logger.warning(.init(stringLiteral: "Connectivity status: \(status).\nUnable to fetch stations. Use fallback case"))
            }
        }
    }
    
    func assembleViewControllers() -> [UIViewController] {
        return lookupViewControllers.compactMap {
            (($0.value).assembly() as? UIViewController)?
                .withNavigationContainer()
                .tabBarItem(TabBarItem(type: $0.key))
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 20.0,
            repeats: true
        ) { [weak self] _ in
            self?.stationRepository.fetchStations()
        }

        RunLoop.current.add(timer!, forMode: .common)
    }
}
