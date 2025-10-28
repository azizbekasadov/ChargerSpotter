//
//  DI+LocationManager.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import Foundation
import CPUtilsKit
import Factory

extension Container {
    var locationManager: Factory<LocationManagerPresentable> {
        self { @MainActor in
            LocationManager.shared
        }
    }
}
