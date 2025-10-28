//
//  MainTabViewModel.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Combine
import Network
import Factory
import Foundation
import CPUtilsKit
import CoreLocation

final class MainTabViewModel: NSObject, ObservableObject {
    
    @Published var userLocation: CLLocation? = nil
    @Published var errorMessage: String?
    
    // MARK: - Private
    
    private(set) var container: Container!
    
    private var timer: Timer?
    private var connectionManager: Connectionable?
    
    private(set) var stationRepository: StationRepository!
    private let locationManager = CLLocationManager()

    convenience init(container: Container) {
        self.init()
        
        self.container = container
        self.connectionManager = container.connectionManager.resolve()
        self.stationRepository = container.stationRepository.resolve()
        // Init
        
        setupLocationManager()
        
        connectionManager?.onConnectionStatusChanged { [weak self] status in
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

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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

extension MainTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            logger.error(.init(stringLiteral: "Error: location Authorization denied."))
        default:
            logger.warning(.init(stringLiteral: "Unknown case for CLLocationManager authorizationStatus"))
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        logger.info(.init(stringLiteral: "User's location: \(location.coordinate.latitude),\(location.coordinate.longitude)"))

        manager.stopUpdatingLocation()
        userLocation = location
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        errorMessage = error.localizedDescription
        logger.error(.init(stringLiteral: "Error: \(error.localizedDescription)"))
    }
}
