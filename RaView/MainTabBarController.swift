//
//  MainTabBarController.swift
//  RaView
//
//  Created by 南山駿人 on 2019/03/01.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit
import FontAwesome_swift
import SwipeableTabBarController

class UITabBarController: SwipeableTabBarController {
    // Do all your subclassing as a regular UITabBarController.
}

class MainTabBarController: UITabBarController {
    
    // MARK: - Navigation

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tab
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9171380401, green: 0.9172917604, blue: 0.9171177745, alpha: 1)
        UITabBar.appearance().isTranslucent = false
        
        // ページを格納する配列
        var viewControllers: [UIViewController] = []
        
        let homeSB = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeSB.instantiateInitialViewController()! as UIViewController
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 1)
        viewControllers.append(homeVC)
        
        let searchSB = UIStoryboard(name: "Search", bundle: nil)
        let searchVC = searchSB.instantiateInitialViewController()! as UIViewController
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage.fontAwesomeIcon(name: .search, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 2)
        viewControllers.append(searchVC)
        
        let thirdSB = UIStoryboard(name: "Third", bundle: nil)
        let thirdVC = thirdSB.instantiateInitialViewController()! as UIViewController
        thirdVC.tabBarItem = UITabBarItem(title: "Third", image: UIImage.fontAwesomeIcon(name: .plusSquare, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 3)
        viewControllers.append(thirdVC)
        
        let postSB = UIStoryboard(name: "Post", bundle: nil)
        let postVC = postSB.instantiateInitialViewController()! as UIViewController
        postVC.tabBarItem = UITabBarItem(title: "Post", image: UIImage.fontAwesomeIcon(name: .plusSquare, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 4)
        viewControllers.append(postVC)
        
        self.viewControllers = viewControllers.map{ UINavigationController(rootViewController: $0)}
        self.setViewControllers(viewControllers, animated: false)

        
        let naviVC = CustomNavigationController(rootVC: homeVC, naviBarClass: CustomNavigationBar.self, toolbarClass: nil)
//        let naviVC2 = CustomNavigationController(rootVC: searchVC, naviBarClass: CustomNavigationBar.self, toolbarClass: nil)
//        let naviVC3 = CustomNavigationController(rootVC: thirdVC, naviBarClass: CustomNavigationBar.self, toolbarClass: nil)
        
//        let tabs = [naviVC, naviVC2, naviVC3]
        let tabs = [naviVC, searchVC, /*thirdVC,*/ postVC]
        self.viewControllers = tabs
    }
    
}
