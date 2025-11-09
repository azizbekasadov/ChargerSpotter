//
//  SceneDelegate.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
import CPUIKit
import Factory
import CPUtilsKit
import CPNetworkKit
import CPStorageKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let container = Container()
    private var appCoordinator: Coordinator!
    
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        self.window = UIWindow(windowScene: windowScene)
        self.appCoordinator = AppCoordinator(
            window: self.window,
            container: self.container
        )
        self.appCoordinator.start()
        
        Task {
            await setupDependencies()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // TODO: Clean it up
        container.storageService.resolve().write()
    }
    
    // MARK: - Composition Root
    
    private func setupDependencies() async {
        container.storageService.register { @MainActor in
            CPCoreDataStorageService.shared
        }
        container.locationManager.register { @MainActor in
            LocationManager.shared
        }
        container.networkService.register {
            ClientAPIService()
        }
    }
}

