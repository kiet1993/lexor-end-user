//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

public protocol AppTabBarControllerColorStyles {
    var primary: UIColor { get }
    var primaryContent: UIColor { get }
    var secondaryContent: UIColor { get }
    var header: UIColor { get }
    var base: UIColor { get }
    var baseLine: UIColor { get }
}

protocol AppTabbarControllerDismissDelegate: AnyObject {
    func appTabbarController(_ tabbarController: AppTabbarController, didDismissVC viewcontroller: UIViewController?)
}

class AppTabbarController: UITabBarController {
    
    weak var appTabbarControllerDismissDelegate: AppTabbarControllerDismissDelegate?
    var internetDeferer: InternetConnectionAvailableDefererType
    
    deinit {
        print("Deinit \(self.classForCoder)")
    }
    
    init(internetDeferer: InternetConnectionAvailableDefererType) {
        self.internetDeferer = internetDeferer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorStyles()
        showContent()
    }
    
    func showContent() {
        let homeVC = HomeViewController()
        let homeNV = AppNavigationController(rootViewController: homeVC)
        homeNV.tabBarItem = UITabBarItem(title: "Home",
                                         image: #imageLiteral(resourceName: "ic_search"),
                                         selectedImage: #imageLiteral(resourceName: "ic_search"))
        let meVC = MeViewController()
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
        
        let viewControllers: [AppNavigationController] = [homeNV,
                                                          meNC,
                                                          libraryNV,
                                                          profileNV]
        
        setViewControllers(viewControllers, animated: true)
    }
    
    func setupColorStyles() {
        tabBar.tintColor = .systemRed
        tabBar.barTintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        tabBar.isTranslucent = false
        view.backgroundColor = .basWhite
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        if index == selectedIndex, let scrollToTopable = viewControllers?[index] as? ContentScrollToTopable {
            scrollToTopable.scrollToTop()
        }
    }
    
    func dismissModalScreen(_ completionHandler: @escaping () -> Void) {
        if let presentedViewController = presentedViewController {
            dismiss(animated: true, completion: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.appTabbarControllerDismissDelegate?.appTabbarController(strongSelf, didDismissVC: presentedViewController)
                completionHandler()
            })
        } else {
            appTabbarControllerDismissDelegate?.appTabbarController(self, didDismissVC: nil)
            DispatchQueue.main.async(execute: completionHandler)
        }
    }
    
}

public protocol ContentScrollToTopable {
    func scrollToTop()
}
