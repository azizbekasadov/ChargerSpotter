//
//  AppCoordinator.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
import CPUIKit
import Factory

final class AppCoordinator: NSObject, Coordinator {
    
    private let container: Container
    private var navigationController: UINavigationController!
    private weak var window: UIWindow?
    
    init(
        window: UIWindow?,
        container: Container
    ) {
        self.window = window
        self.container = container
    }
    
    func start() {
        let rootViewController = MainTabBarAssembly(
            container: self.container
        )
        .assembly()
        
        let navigationController = UINavigationController(
            rootViewController: rootViewController
        )
        navigationController.view.backgroundColor = UIColor.systemBackground
        navigationController.setNavigationBarHidden(true, animated: false)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}
