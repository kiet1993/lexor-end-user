//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UITabBarController {
    func selectViewControllerAtIndex(_ index: Int, completionHandler: @escaping () -> Void = {}) {
        if self.selectedIndex != index {
            self.selectedIndex = index
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: completionHandler)
        } else {
            completionHandler()
        }
    }

    func popToRootVC(_ completionHandler: @escaping () -> Void = {}) {
        guard let navVC = self.selectedViewController as? UINavigationController else {
            completionHandler()
            return
        }
        if navVC.viewControllers.count > 1 {
            navVC.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(350), execute: completionHandler)
        } else {
            completionHandler()
        }
    }

    func selectViewControllerAndPopToRoot(tabIndex index: Int, completionHandler: @escaping () -> Void = {}) {
        self.selectViewControllerAtIndex(index) { [weak self] in
            self?.popToRootVC(completionHandler)
        }
    }

    func getIndexOf(viewController: UIViewController.Type) -> Int {
        if
            let viewControllers = self.viewControllers,
            let index = viewControllers.firstIndex(where: { ($0 as? UINavigationController)?.viewControllers.first?.isKind(of: viewController) ?? false }) {
            return index
        }

        return 0
    }
}
