//
//  TabBarViewController.swift
//  Spotify
//
//  Created by A'zamjon Abdumuxtorov on 01/02/26.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        setupViewControllers()
    }
    
    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViewControllers() {
        viewControllers = TabBar.allCases.map(makeNav)
    }
    
    private func makeNav(_ tab:TabBar) -> UINavigationController {
        let root = tab.viewController
        root.view.backgroundColor = .systemBackground
        root.navigationItem.largeTitleDisplayMode = .always
        let nav = UINavigationController(rootViewController: tab.viewController)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: tab.title, image: UIImage(systemName: tab.imageName),tag: tab.rawValue)
        return nav
    }
}


