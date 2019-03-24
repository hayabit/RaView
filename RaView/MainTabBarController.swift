//
//  MainTabBarController.swift
//  RaView
//
//  Created by 南山駿人 on 2019/03/01.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainTabBarController: UITabBarController {
    
    // MARK: - Navigation

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tab
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        UITabBar.appearance().isTranslucent = false
        
        // ページを格納する配列
        var viewControllers: [UIViewController] = []
        
        let firstSB = UIStoryboard(name: "First", bundle: nil)
        let firstVC = firstSB.instantiateInitialViewController()! as UIViewController
        firstVC.tabBarItem = UITabBarItem(title: "", image: UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 1)
        viewControllers.append(firstVC)
        
        let secondSB = UIStoryboard(name: "Second", bundle: nil)
        let secondVC = secondSB.instantiateInitialViewController()! as UIViewController
        secondVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage.fontAwesomeIcon(name: .search, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 2)
        viewControllers.append(secondVC)
        
        let thirdSB = UIStoryboard(name: "Third", bundle: nil)
        let thirdVC = thirdSB.instantiateInitialViewController()! as UIViewController
        thirdVC.tabBarItem = UITabBarItem(title: "Third", image: UIImage.fontAwesomeIcon(name: .plusSquare, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 3)
        viewControllers.append(thirdVC)
        
        let PostSB = UIStoryboard(name: "Post", bundle: nil)
        let PostVC = PostSB.instantiateInitialViewController()! as UIViewController
        PostVC.tabBarItem = UITabBarItem(title: "Post", image: UIImage.fontAwesomeIcon(name: .plusSquare, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), tag: 4)
        viewControllers.append(PostVC)
        
        self.viewControllers = viewControllers.map{ UINavigationController(rootViewController: $0)}
        self.setViewControllers(viewControllers, animated: false)

        
        let naviVC = CustomNavigationController(rootVC: firstVC, naviBarClass: CustomNavigationBar.self, toolbarClass: nil)
//        let naviVC2 = CustomNavigationController(rootVC: secondVC, naviBarClass: CustomNavigationBar.self, toolbarClass: nil)
//        let naviVC3 = CustomNavigationController(rootVC: thirdVC, naviBarClass: CustomNavigationBar.self, toolbarClass: nil)
        
//        let tabs = [naviVC, naviVC2, naviVC3]
        let tabs = [naviVC, secondVC, thirdVC, PostVC]
        self.viewControllers = tabs
    }
    
}
