//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UINavigationItem {
    func getShadowBackButton(tintColor: UIColor, shadowColor: UIColor, actionOn: UIViewController, backAction: Selector) {
        let backImage = #imageLiteral(resourceName: "icon-back-navi").withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(backImage, for: .normal)
        button.tintColor = tintColor
        button.addTarget(actionOn, action: backAction, for: .touchUpInside)
        leftBarButtonItem = UIBarButtonItem(customView: button)
        leftBarButtonItem?.customView?.applyShadow(color: shadowColor, alpha: 0.5, xOrigin: 0, yOrigin: 0, blur: 5, spread: 0)
    }
}

extension UINavigationController {
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}
