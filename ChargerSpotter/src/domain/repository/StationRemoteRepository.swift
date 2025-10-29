//
//  StationRemoteRepository.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

protocol StationRemoteRepositoryPresentable {
    func fetchStaticData() async throws -> EVSERoot
    func fetchDynamicData() async throws -> EVSEStatusesRoot
}

final class StationRemoteRepository: StationRemoteRepositoryPresentable {
    private let networkClientAPI: EVStationNetworkServiceProviding
    
    init(networkClientAPI: EVStationNetworkServiceProviding) {
        self.networkClientAPI = networkClientAPI
    }
    
    func fetchStaticData() async throws -> EVSERoot {
        try await networkClientAPI.fetchStaticData()
    }

    func fetchDynamicData() async throws -> EVSEStatusesRoot {
        try await networkClientAPI.fetchDynamicData()
    }
}
