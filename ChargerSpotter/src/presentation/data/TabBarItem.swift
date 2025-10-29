//
//  TabBarItem.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 27.10.2025.
//

import Foundation

enum TabBarType: String, Identifiable, Hashable {
    case map
    case list
    
    var id: String {
        self.rawValue
    }
    
    var tag: Int {
        switch self {
        case .map:
            return 0
        case .list:
            return 1
        }
    }
    
    var title: String {
        switch self {
        case .map:
            return "Maps"
        case .list:
            return "Stations"
        }
    }
    
    var imageName: String {
        switch self {
        case .map:
            return "map"
        case .list:
            return "list.bullet.rectangle.portrait"
        }
    }
    
    var selectedImageName: String {
        switch self {
        case .map:
            return "map.fill"
        case .list:
            return "list.bullet.rectangle.portrait.fill"
        }
    }
}

struct TabBarItem: Identifiable, Hashable {
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id.uuidString+"\(self.tag)")
    }
}

extension TabBarItem {
    init(type: TabBarType) {
        self.id = UUID()
        self.title = type.title
        self.tag = type.tag
        self.imageName = type.imageName
        self.selectedImageName = type.selectedImageName
    }
}

extension TabBarItem {
    static let tabs: [TabBarItem] = [
        TabBarItem(
            tag: 0,
            title: "Maps",
            imageName: "map",
            selectedImageName: "map.fill"
        ),
        TabBarItem(
            tag: 1,
            title: "Stations",
            imageName: "list.bullet.rectangle.portrait",
            selectedImageName: "list.bullet.rectangle.portrait.fill"
        )
    ]
}
