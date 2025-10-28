//
//  LocationManager.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Combine
import CoreLocation

internal import Logging

public protocol LocationManagerPresentable {
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
    
    func requestOneShotLocation()
    func startContinuousUpdates()
    func stop()
}

@MainActor
public final class LocationManager: NSObject, ObservableObject, LocationManagerPresentable {
    // MARK: - Published state (for SwiftUI/Combine bindings)
    @Published public private(set) var userLocation: CLLocation?
    @Published public private(set) var errorMessage: String?

    public var locationPublisher: AnyPublisher<CLLocation, Never> {
        $userLocation.compactMap { $0 }.eraseToAnyPublisher()
    }

    public var errorPublisher: AnyPublisher<String, Never> {
        $errorMessage.compactMap { $0 }.eraseToAnyPublisher()
    }

    private let locationManager = CLLocationManager()
    private var wantsContinuousUpdates = false

    public static let shared: LocationManagerPresentable = LocationManager()
    
    public override init() {
        super.init()
        setupLocationManager()
    }

    public func requestOneShotLocation() {
        wantsContinuousUpdates = false
        handleAuthorizationAndStart(true)
    }

    public func startContinuousUpdates() {
        wantsContinuousUpdates = true
        handleAuthorizationAndStart(false)
    }
    
    public func stop() {
        locationManager.stopUpdatingLocation()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }

    private func handleAuthorizationAndStart(_ shouldRequestOnce: Bool) {
        guard CLLocationManager.locationServicesEnabled() else {
            errorMessage = "Location Services are disabled."
            logger.error("Location Services disabled.")
            return
        }

        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            start(shouldRequestOnce)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            errorMessage = "Location permission denied. Please enable it in Settings."
            logger.error("Location authorization denied or restricted.")
        @unknown default:
            errorMessage = "Unknown location authorization state."
            logger.warning("Unknown authorization state.")
        }
    }

    private func start(_ shouldRequestOnce: Bool) {
        if shouldRequestOnce {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if wantsContinuousUpdates {
                manager.startUpdatingLocation()
                logger.info(.init(stringLiteral: "Requesting user location with updates"))
            } else {
                manager.requestLocation()
                logger.info(.init(stringLiteral: "Requesting user location with updates"))
            }
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            errorMessage = "Location permission denied. Please enable it in Settings."
            logger.error("Authorization denied/restricted after change.")
        @unknown default:
            errorMessage = "Unknown authorization state."
            logger.warning("Unknown authorization state after change.")
        }
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        
        userLocation = location
        
        logger.info("User location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        if !wantsContinuousUpdates {
            manager.stopUpdatingLocation()
        }
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        errorMessage = error.localizedDescription
        logger.error("Location error: \(error.localizedDescription)")
    }
}
