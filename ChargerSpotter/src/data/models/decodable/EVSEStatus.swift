//
//  EVSEStatus.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

struct EVSEStatus: Decodable {
    let operatorID: String
    let operatorName: String
    let statusRecords: [EVSEStatusRecord]

    enum CodingKeys: String, CodingKey {
        case operatorID = "OperatorID"
        case operatorName = "OperatorName"
        case statusRecords = "EVSEStatusRecord"
    }
}
