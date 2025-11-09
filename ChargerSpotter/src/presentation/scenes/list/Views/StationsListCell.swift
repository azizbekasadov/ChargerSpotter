//
//  StationsListCell.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 30.10.2025.
//

import SwiftUI

struct StationsListCell: View {
    let station: UniqueStation
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Station " + station.stationId)
                .font(.body)
                .fontWeight(.bold)
            
            HStack {
                Image(systemName: "ev.charger")
                    .foregroundColor(Color(station.availability.tintColor))
                
                Text("\(station.maxPower)kW")
                    .font(.body)
            }
            
            if let lastUpdate = station.lastUpdate {
                Text("Last Update: \(DateFormatter.formatter.string(from: lastUpdate))")
                    .font(.footnote)
            }
        }
    }
}

extension StationsListCell: Equatable {
    static func == (
        lhs: StationsListCell,
        rhs: StationsListCell
    ) -> Bool {
        lhs.station.stationId == rhs.station.stationId
    }
}
