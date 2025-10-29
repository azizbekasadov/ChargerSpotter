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

    convenience init(container: Container) {
        self.init()
        
        self.container = container
        self.connectionManager = container.connectionManager.resolve()
        self.stationRepository = container.stationRepository.resolve()
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
        return [
            MapViewControllerAssembly(
                container: self.container,
                stationRepository: self.stationRepository
            )
            .assembly()
            .withNavigationContainer()
            .tabBarItem(TabBarItem(type: .map)),
            
            ListViewAssembly(
                container: self.container,
                stationRepository: self.stationRepository
            )
            .assembly()
            .withNavigationContainer()
            .tabBarItem(TabBarItem(type: .list))
        ]
    }

    private func startTimer() {
        stationRepository.fetchStations()
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 180,
            repeats: true
        ) { [weak self] _ in
            self?.stationRepository.fetchStations()
        }

        RunLoop.current.add(timer!, forMode: .common)
    }
}
