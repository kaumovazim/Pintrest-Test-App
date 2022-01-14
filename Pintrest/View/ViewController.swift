//
//  ViewController.swift
//  Pintrest
//
//  Created by User on 12/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    let tabBar = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabBarController()
        
    }

    func createTabBarController() {
    
        let randomView = RandomViewController()
        let randomNavigation = UINavigationController(rootViewController: randomView)
            randomNavigation.tabBarItem = UITabBarItem.init(title: "Лента", image: UIImage(systemName: "circle.grid.2x2.fill"), tag: 0)
        
        let wishlistView = WishlistViewController()
        let wishlistNavigation = UINavigationController(rootViewController: wishlistView)
            wishlistNavigation.tabBarItem = UITabBarItem.init(title: "Избранное", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        tabBar.viewControllers = [randomNavigation, wishlistNavigation]
        self.view.addSubview(tabBar.view)
    }

}


