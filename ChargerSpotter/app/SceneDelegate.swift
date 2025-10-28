//
//  SceneDelegate.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
import CPUIKit
import Factory

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

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
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
//        storageService.context.save() // use DI
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

