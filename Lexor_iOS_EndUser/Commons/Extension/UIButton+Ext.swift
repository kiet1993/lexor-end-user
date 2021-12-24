//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UIButton {
    func setUpButtonWithLoginStyle(font: UIFont, title: String, titleColor: UIColor, backgroundColor: UIColor) {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(titleColor, for: .normal)
    }

    func setBackgroundColor(color: UIColor?, state: UIControl.State) {
        switch state {
        case .normal, .selected, .disabled:
            break
        case .highlighted:
            adjustsImageWhenHighlighted = false
        default:
            break
        }
        guard let color = color else { return }
        setBackgroundImage(self.imageWithColor(color: color), for: state)
    }

    func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
