//
//  StationsListView.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import SwiftUI
import CoreLocation

struct StationsListView: View {
    @ObservedObject var viewModel: ListViewModel

    var body: some View {
        List {
            ForEach(viewModel.stations.sorted(by: .maxPower)) { station in
                StationChipView(station)
            }
        }
        .listStyle(.plain)
        .background(Color(uiColor: .systemBackground))
    }
    
    @ViewBuilder
    private func StationChipView(_ station: UniqueStation) -> some View {
        VStack(alignment: .leading) {
            Text(station.stationName ?? "Station " + station.stationId)
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
