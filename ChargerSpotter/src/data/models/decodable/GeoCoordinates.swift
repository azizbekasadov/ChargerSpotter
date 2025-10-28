//
//  GeoCoordinates.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation
import CoreLocation

struct GeoCoordinates: Decodable {
    let google: String

    enum CodingKeys: String, CodingKey {
        case google = "Google"
    }

    var locationCoordinate2D: CLLocationCoordinate2D? {
        let coords = google.split(separator: " ")

        guard
            coords.count == 2,
            let latitude = Double(coords[0]),
            let longitude = Double(coords[1])
        else {
            logger.error(.init(stringLiteral: "Unable to parse location coordinates: \(coords)"))
            return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
