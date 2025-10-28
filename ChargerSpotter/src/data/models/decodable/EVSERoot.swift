//
//  EVSERoot.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

struct EVSERoot: Decodable {
    let evseData: [EVSEData]

    enum CodingKeys: String, CodingKey {
        case evseData = "EVSEData"
    }
}
