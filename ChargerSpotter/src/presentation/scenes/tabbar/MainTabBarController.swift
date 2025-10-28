//
//  MainTabBar.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let viewModel: MainTabViewModel
    
    public init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            MapViewControllerAssembly(
                container: self.viewModel.container
            )
            .assembly()
            .withNavigationContainer()
            .tabBarItem(
                TabBarItem(
                    tag: 0,
                    title: "Maps",
                    imageName: "map",
                    selectedImageName: "map.fill"
                )
            ),
            ListViewAssembly(
                container: self.viewModel.container
            )
            .assembly()
            .withNavigationContainer()
            .tabBarItem(
                TabBarItem(
                    tag: 1,
                    title: "Stations",
                    imageName: "list.bullet.rectangle.portrait",
                    selectedImageName: "list.bullet.rectangle.portrait.fill"
                )
            ),
        ]
    }
}
