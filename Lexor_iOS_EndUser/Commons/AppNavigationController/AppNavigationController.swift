//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

class AppNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIGraphicsImageRenderer(size: .init(width: 1, height: 1)).image { ctx in
            ctx.cgContext.setFillColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor)
            ctx.fill(.init(x: 0, y: 0, width: 1, height: 1))
        }

        navigationBar.titleTextAttributes = [ .foregroundColor: UIColor.bas80,
                                              .font: UIFont.basHeadingMedium(ofSize: 16)]

        interactivePopGestureRecognizer?.delegate = self
        navigationBar.barTintColor = .basWhite
        navigationBar.tintColor = .bas80
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    @objc
    func handleBack(_ sender: Any) {
        self.popViewController(animated: true)
    }
}

extension AppNavigationController: ContentScrollToTopable {
    func scrollToTop() {
        if viewControllers.count == 1, let rootVC = topViewController as? ContentScrollToTopable {
            rootVC.scrollToTop()
        }
    }
}
