//
//  TabBarController.swift
//  Lexor_iOS_EndUser
//
//  Created by DucPD on 2021/10/12.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemRed
        tabBar.barTintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        tabBar.isTranslucent = false
    }
}
