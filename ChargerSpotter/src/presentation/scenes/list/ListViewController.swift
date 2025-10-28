//
//  ListViewController.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

final class ListViewController: BaseViewController {

    private lazy var stationsListView: UIViewController = {
        let stationsListView = StationsListViewAssembly(
            viewModel: self.viewModel
        )
        .assembly()
        
        stationsListView.view.translatesAutoresizingMaskIntoConstraints = false
        return stationsListView
    }()
    
    private var searchController: UISearchController?
    
    private let viewModel: ListViewModel

    // MARK: - Initialization

    public init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    override func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        searchController = UISearchController()
        
        navigationItem.searchController = searchController
        navigationItem.title = "Near Me"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupStationsListView()
        setupSortingView()
    }
    
    override func setupBindings() {
        searchController?.searchBar.text
            .publisher
            .debounce(for: 100, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchText in
                //                self?.viewModel.performSearch(with: searchText)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupStationsListView() {
        addChild(stationsListView)
        view.addSubview(stationsListView.view)
        view.backgroundColor = .systemBackground
        navigationController?.view.backgroundColor = .systemBackground
        stationsListView.didMove(toParent: self)

        NSLayoutConstraint.activate([
            stationsListView.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stationsListView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stationsListView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        if #available(iOS 26, *) {
            stationsListView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            stationsListView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    private func setupSortingView() {
        let sortMenuItems: [UIKeyCommand] = StationsSortingOptions.allCases.map {
            UIKeyCommand(
                title: $0.title,
                action: #selector(handleSortChange),
                input: $0.id
            )
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "arrow.up.arrow.down"),
            target: self,
            action: #selector(handleSortChange),
            menu: UIMenu.init(
                title: "Sort Stations By",
                options: [.singleSelection],
                children: sortMenuItems
            )
        )
    }
    
    @objc
    private func handleSortChange() {
        
    }
}

enum StationsSortingOptions: String, Identifiable, CaseIterable {
    case ascending
    case descending
    
    var id: String {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .ascending:
            return "Ascending"
        case .descending:
            return "Descending"
        }
    }
}
