//
//  EVSEStatusesRoot.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

struct EVSEStatusesRoot: Decodable {
    let statuses: [EVSEStatus]

    enum CodingKeys: String, CodingKey {
        case statuses = "EVSEStatuses"
    }
}
