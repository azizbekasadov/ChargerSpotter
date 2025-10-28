//
//  StationRemoteRepositoryPresentable.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Foundation

@testable import ChargerSpotter

final class MockStationRemoteRepository: StationRemoteRepositoryPresentable {
    
    func fetchStaticData() async throws -> Data {
        return Data()
    }
    
    func fetchDynamicData() async throws -> Data {
        return Data()
    }
    
}
