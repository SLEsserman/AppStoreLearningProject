//
//  BaseTabBarController.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/6/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        viewControllers = [
            createNavController(viewController: TodayController(), title: "Today", imageName: "today_icon"),
            createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppSearchController(), title: "Search", imageName: "search"), 
            
        ]
    }
    
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController                               = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles  = true
        viewController.navigationItem.title             = title
        viewController.view.backgroundColor             = .white
        navController.tabBarItem.title                  = title
        navController.tabBarItem.image                  = UIImage(named: imageName)
        
        return navController
    }
}
