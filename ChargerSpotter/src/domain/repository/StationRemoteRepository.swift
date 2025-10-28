//
//  StationRemoteRepository.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

protocol StationRemoteRepositoryPresentable {
    func fetchStaticData() async throws -> Data
    func fetchDynamicData() async throws -> Data
}

final class StationRemoteRepository: StationRemoteRepositoryPresentable {
    func fetchStaticData() async throws -> Data {
        let (data, _) = try await URLSession.shared.data(
            from: AppConfig.API.staticDataURL,
            delegate: nil
        )
        return data
    }

    func fetchDynamicData() async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: AppConfig.API.dynamicDataURL, delegate: nil)
        return data
    }
}
