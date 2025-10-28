//
//  EVSEStatusRecord.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

struct EVSEStatusRecord: Decodable {
    let evseId: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case evseId = "EvseID"
        case status = "EVSEStatus"
    }
}
