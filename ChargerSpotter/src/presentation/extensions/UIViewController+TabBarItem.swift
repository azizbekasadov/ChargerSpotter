//
//  UIViewController+TabBarItem.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
import CPUIKit

extension UIViewController {
    @discardableResult
    func tabBarItem(
        _ tabBarItem: TabBarItem
    ) -> Self {
        self.tabBarItem.title = tabBarItem.title
        self.tabBarItem.image = tabBarItem.imageName.image
        self.tabBarItem.selectedImage = tabBarItem.selectedImageName.image
        self.view.tag = tabBarItem.tag
        self.restorationIdentifier = tabBarItem.id.uuidString
        
        return self
    }
}
