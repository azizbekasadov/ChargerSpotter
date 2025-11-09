//
//  Station+Location.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation
import CoreLocation

extension EVStation {
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
