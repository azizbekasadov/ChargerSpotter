//
//  Assembly.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import UIKit
//import SwiftUI

public protocol Assembliable {
    associatedtype T = UIViewController
    
    func assembly() -> T
}
