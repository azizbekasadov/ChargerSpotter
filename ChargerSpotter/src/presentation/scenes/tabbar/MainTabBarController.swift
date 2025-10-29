//
//  MainTabBar.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
import CPUIKit

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
        
        viewControllers = viewModel.assembleViewControllers()
    }
}
