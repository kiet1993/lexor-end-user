//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UIFont {
    class func basHeading(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Black", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    class func basHeadingRe(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    class func basHeadingBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }

    class func basHeadingMedium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    /// - No need set-up
    class func robotoBlackItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-BlackItalic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }

    class func robotoBoldItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-BoldItalic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }

    class func robotoItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Italic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    class func robotoLight(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    class func robotoLightItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-LightItalic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    class func robotoMediumItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-MediumItalic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    class func robotoThin(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    class func robotoThinItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-ThinItalic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
}
