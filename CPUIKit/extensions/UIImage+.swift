//
//  UIImage+.swift
//  CPUIKit
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit

extension String {
    public var image: UIImage? {
        UIImage(named: self) ?? UIImage(systemName: self)
    }
}
