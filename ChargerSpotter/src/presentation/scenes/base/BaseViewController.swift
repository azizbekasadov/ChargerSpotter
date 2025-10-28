//
//  BaseViewController.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
        
        setupUI()
        setupBindings()
    }

    func setupUI() {}

    func setupBindings() {}
}
