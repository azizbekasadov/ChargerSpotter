//
//  EVSEData.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

struct EVSEData: Decodable {
    let operatorID: String
    let operatorName: String
    let dataRecords: [EVSEDataRecord]

    enum CodingKeys: String, CodingKey {
        case operatorID = "OperatorID"
        case operatorName = "OperatorName"
        case dataRecords = "EVSEDataRecord"
    }
}
