//
//  AppCoordinator.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit
import CoreMotion

protocol AppNavigator: AnyObject {
    func toSearch()
    func toRegister()
}

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    let internetDeferer = InternetConnectionAvailableDeferer()
    let keychainManager = KeychainServiceManager()
    
    private lazy var tabBarController = TabBarController()
    
    private let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        super.init(rootNavigationController: navigationController)
    }
    
    private func setupNavigation() {
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func start() {
        window.rootViewController = navigationController
        setupNavigation()
        tabBarController.setViewControllers(createTabs(), animated: false)
        setRoot(tabBarController, animated: false)
    }
    
    private func createTabs() -> [UIViewController] {
        let homeVC = HomeViewController()
        homeVC.viewModel = HomeViewModel(navigator: self)
        
        let homeNV = AppNavigationController(rootViewController: homeVC)
        homeNV.tabBarItem = UITabBarItem(title: "Home",
                                         image: #imageLiteral(resourceName: "ic_search"),
                                         selectedImage: #imageLiteral(resourceName: "ic_search"))
        let meVC = MeViewController()
        meVC.delegate = self
        let meNC = AppNavigationController(rootViewController: meVC)
        meNC.tabBarItem = UITabBarItem(title: "Profile",
                                       image: #imageLiteral(resourceName: "ic_person"),
                                       selectedImage: #imageLiteral(resourceName: "ic_person"))
        let libraryNV = AppNavigationController()
        libraryNV.tabBarItem = UITabBarItem(title: "Collections",
                                            image: #imageLiteral(resourceName: "ic_map"),
                                            selectedImage: #imageLiteral(resourceName: "ic_map"))
        let moreVC = MoreVC()
        let profileNV = AppNavigationController(rootViewController: moreVC)
        profileNV.tabBarItem = UITabBarItem(title: "More",
                                            image: #imageLiteral(resourceName: "ic_setting"),
                                            selectedImage: #imageLiteral(resourceName: "ic_setting"))
        
        return [homeNV,
                meNC,
                libraryNV,
                profileNV]
    }
}

extension AppCoordinator: AppNavigator {
    func toSearch() {
        let coordinator = SearchCoordinator()
        addChild(coordinator)
        coordinator.start()
        present(coordinator)
    }
    
    func toRegister() {
        
    }
}

extension AppCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        userDefaults[.kTabBarPreviousSelectedIndex] = tabBarController.selectedIndex
        return true
    }
}

extension AppCoordinator: MeViewControllerDelegate {
    func controller(_ controller: MeViewController, needsPerform action: MeViewController.Action) {
        switch action {
        case .cancel:
            tabBarController.selectedIndex = userDefaults[.kTabBarPreviousSelectedIndex, 0]
        }
    }
}

