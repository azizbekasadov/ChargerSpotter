//
//  MapViewModel.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Combine
import Network
import Foundation
import CPUtilsKit
import CoreLocation

final class MapViewModel: NSObject, ObservableObject {
    private(set) var stationRepository: StationRepository
    
    private let locationPublisher: Published<CLLocation?>.Publisher
    private var cancellables = Set<AnyCancellable>()
    
    var updateOwnLocation: ((CLLocation) -> Void)?
    var handleLoadState: ((StationRepository.LoadState) -> Void)?
    
    init(
        stationRepository: StationRepository,
        locationPublisher: Published<CLLocation?>.Publisher
    ) {
        self.stationRepository = stationRepository
        self.locationPublisher = locationPublisher
        
        super.init()
        
        stationRepository.$loadState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                self?.handleLoadState?(state)
            })
            .store(in: &cancellables)

        locationPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] userLocation in
                self?.updateOwnLocation?(userLocation)
            })
            .store(in: &cancellables)
    }
    
    
}
