//
//  TabBar.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 01/02/26.
//

import UIKit

enum TabBar: Int, CaseIterable {
    case home = 0
    case search = 1
    case library = 2
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .library:
            return "Library"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .library:
            return "music.note.list"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .search:
            return SearchViewController()
        case .library:
            return LibraryViewController()
        }
    }
}
