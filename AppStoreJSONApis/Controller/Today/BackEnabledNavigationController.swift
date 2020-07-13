//
//  BackEnabledNavigationController.swift
//  AppStoreJSONApis
//
//  Created by Samuel Esserman on 5/28/20.
//  Copyright © 2020 Samuel Esserman. All rights reserved.
//

import UIKit


class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
    
}
