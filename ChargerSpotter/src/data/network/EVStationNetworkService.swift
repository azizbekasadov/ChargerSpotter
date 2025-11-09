//
//  EVStationNetworkService.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import Foundation
import CPNetworkKit
import CPUtilsKit

protocol EVStationNetworkServiceProviding {
    func fetchStaticData() async throws -> EVSERoot
    func fetchDynamicData() async throws -> EVSEStatusesRoot
}

final class EVStationNetworkService: EVStationNetworkServiceProviding {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchStaticData() async throws -> EVSERoot {
        try await networkService.fetch(
            from: AppConfig.API.staticDataURL
        )
    }
    
    func fetchDynamicData() async throws -> EVSEStatusesRoot {
        try await networkService.fetch(
            from: AppConfig.API.dynamicDataURL
        )
    }
}
