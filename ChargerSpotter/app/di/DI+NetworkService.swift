//
//  DI+NetworkService.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import Factory
import Foundation
import CPNetworkKit

extension Container {
    var networkService: Factory<NetworkService> {
        self {
            ClientAPIService()
        }
    }
}
