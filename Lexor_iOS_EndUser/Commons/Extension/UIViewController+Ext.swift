//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UIViewController {
    static var alertTintColor: UIColor?

    func showAlert(title: String? = "Alert", message: String? = nil, presentCompletionHandler: (() -> Void)? = nil, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in handler?()})
        if let alertTintColor = UIViewController.alertTintColor {
            alert.view.tintColor = alertTintColor
        }
        present(alert, animated: true, completion: presentCompletionHandler)
    }

    func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, presentCompletionHandler: (() -> Void)? = nil, completion: ((Int) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: presentCompletionHandler)
    }

    func showAlertNetworkError(presentCompletionHandler: (() -> Void)? = nil, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: "The internet connection seems offline.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in handler?()})
        if let alertTintColor = UIViewController.alertTintColor {
            alert.view.tintColor = alertTintColor
        }
        present(alert, animated: true, completion: presentCompletionHandler)
    }
    
    func showError(_ error: Error, actionHandler: (() -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in actionHandler?() })
        alert.addAction(ok)
        present(alert, animated: true, completion: completionHandler)
    }
}

extension UIViewController {
    
    func makeNavigationBarTransparent(isTranslucent flag: Bool = true) {
        if let navigationBar = navigationController?.navigationBar {
            let blankImage = UIImage()
            navigationBar.setBackgroundImage(blankImage, for: .default)
            navigationBar.shadowImage = blankImage
            navigationBar.isTranslucent = flag
        }
    }
}
