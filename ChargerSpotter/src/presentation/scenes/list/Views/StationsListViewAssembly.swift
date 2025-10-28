//
//  StationsListViewAssembly.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import SwiftUI
import CPUIKit

final class StationsListViewAssembly: Assembliable {
    private let viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    func assembly() -> UIViewController {
        UIHostingController(
            rootView: StationsListView(
                viewModel: self.viewModel
            )
        )
    }
}
