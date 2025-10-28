//
//  StationRepositoryTests.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import XCTest
import Combine
import CoreData
import Foundation
import CPStorageKit

@testable import ChargerSpotter

final class StationRepositoryTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    @MainActor
    func test_loadingCache_forOffline_withNoStations() async throws {
        
    }
    
    @MainActor
    func test_loadingCache_forOffline_withOneStation() async throws {
        
    }
    
    @MainActor
    func test_loadingCache_forOffline_withManyStations() async throws {
        
    }
    
    @MainActor
    func test_fetchStations_onlineWithNoStations() async throws {
        
    }
    
    @MainActor
    func test_fetchStations_onlineWithOneStation() async throws {
        
    }
    
    @MainActor
    func test_fetchStations_onlineWithManyStations() async throws {
        
    }
    
    @MainActor
    func test_loadingCache_forOffline_fromFakeStationLocalRepository_withOneStation() async throws {
        
    }
    
    @MainActor
    func test_loadingCache_forOffline_fromFakeStationLocalRepository_withManyStations() async throws {
        
    }
    
    @MainActor
    func testLoadingCacheForOffline() async throws {
        let expectation = XCTestExpectation(description: "LoadState should have some stations")
        
        let local = MockStationLocalRepository()
        let remoteRepository = MockStationRemoteRepository()
        
        let sut = makeSUT()
        
        sut.$loadState
            .sink { newState in
                switch newState {
                case let .loaded(stations) where !stations.isEmpty:
                    expectation.fulfill()
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        sut.loadCachedData()
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor
    func testFetchStations() async throws {
        let expectation = XCTestExpectation(description: "LoadState should have some stations")
        
        let sut = makeSUT()
        
        sut.$loadState
            .sink { newState in
                switch newState {
                case let .loaded(stations) where !stations.isEmpty:
                    expectation.fulfill()
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        sut.fetchStations()
        
        await fulfillment(of: [expectation], timeout: 15.0)
    }
 
    // MARK: - Helpers
    
    private func makeSUT() -> StationRepository {
        let local = MockStationLocalRepository()
        let remoteRepository = MockStationRemoteRepository()
        
        let sut = StationRepository(
            local: local,
            remote: remoteRepository
        )
        
        return sut
    }
}
