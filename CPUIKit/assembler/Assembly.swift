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
    
    #if canImport(UIKit)
    func assembly() -> T
    #endif
    
//    #if canImport(SwiftUI)
//    @ViewBuilder
//    func assembly() -> AnyView
//    
//    @ViewBuilder
//    func assembly<Content: View>() -> UIHostingController<Content>
//    #endif
}
