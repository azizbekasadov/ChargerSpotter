//
//  StationsListView.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import SwiftUI

struct StationsListView: View {
    @ObservedObject var viewModel: ListViewModel

    var body: some View {
        List {
            ForEach(viewModel.stations.sorted(by: .maxPower)) { station in
                StationsListCell(station: station)
            }
        }
        .listStyle(.plain)
        .background(Color(uiColor: .systemBackground))
    }
}
