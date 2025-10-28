//
//  TabBarItem.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

struct TabBarItem: Identifiable {
    let id: UUID
    let tag: Int
    let title: String
    let imageName: String
    let selectedImageName: String
    
    init(
        id: UUID = .init(),
        tag: Int,
        title: String,
        imageName: String,
        selectedImageName: String
    ) {
        self.id = id
        self.tag = tag
        self.title = title
        self.imageName = imageName
        self.selectedImageName = selectedImageName
    }
}
