//
//  UIViewController+Navigation.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import UIKit

extension UIViewController {
    
    @discardableResult
    func withNavigationContainer() -> UINavigationController {
        let navigationController = UINavigationController(
            rootViewController: self
        )
        
        return navigationController
    }
    
    @discardableResult
    func with(
        _ navigationController: UINavigationController,
        animated: Bool = false
    ) -> UINavigationController {
        navigationController.pushViewController(self, animated: animated)
        return navigationController
    }
}
