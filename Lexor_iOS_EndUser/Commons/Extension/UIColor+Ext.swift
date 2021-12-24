//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }

    static func color(_ hex: Int) -> UIColor {
        return UIColor(hex: hex)
    }

    static var basBluePastel: UIColor {
        return #colorLiteral(red: 0.3215686275, green: 0.4549019608, blue: 0.8, alpha: 1)
    }
    static var basOrangePastel: UIColor {
        return #colorLiteral(red: 0.9490196078, green: 0.6235294118, blue: 0.5019607843, alpha: 1)
    }
    static var basRedPastel: UIColor {
        return #colorLiteral(red: 0.9490196078, green: 0.2980392157, blue: 0.2392156863, alpha: 1)
    }
    static var basBrownPastel: UIColor {
        return #colorLiteral(red: 0.6509803922, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
    }
    static var basBlack: UIColor {
        return .black
    }
    static var bas80: UIColor {
        return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    static var bas60: UIColor {
        return #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    }
    static var bas40: UIColor {
        return #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    }
    static var bas20: UIColor {
        return #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
    static var bas10: UIColor {
        return #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
    }
    static var basWhite: UIColor {
        return .white
    }
    static var basGreen10: UIColor {
        return #colorLiteral(red: 0.9803921569, green: 0.9882352941, blue: 0.9411764706, alpha: 1)
    }
    static var basGreen80: UIColor {
        return #colorLiteral(red: 0.5921568627, green: 0.7019607843, blue: 0.3215686275, alpha: 1)
    }
    static var basGreen60: UIColor {
        return #colorLiteral(red: 0.6745098039, green: 0.7607843137, blue: 0.4588235294, alpha: 1)
    }
    static var basGreen50: UIColor {
        return #colorLiteral(red: 0.7568627451, green: 0.8196078431, blue: 0.5921568627, alpha: 1)
    }
    static var basGreen40: UIColor {
        return #colorLiteral(red: 0.7960784314, green: 0.8509803922, blue: 0.6588235294, alpha: 1)
    }
    static var basGreen30: UIColor {
        return #colorLiteral(red: 0.8352941176, green: 0.8823529412, blue: 0.7294117647, alpha: 1)
    }
    static var basGreenPastel: UIColor {
        return #colorLiteral(red: 0.5803921569, green: 0.8745098039, blue: 0.09803921569, alpha: 1)
    }
    static var basGreenMid: UIColor {
        return #colorLiteral(red: 0.4509803922, green: 0.6666666667, blue: 0.4509803922, alpha: 1)
    }
    static var basGreenGradient: [UIColor] {
        return [#colorLiteral(red: 0.5411764706, green: 0.862745098, blue: 0.007843137255, alpha: 1), #colorLiteral(red: 0.5411764706, green: 0.862745098, blue: 0.007843137255, alpha: 0)]
    }
    static var basGreenLight: UIColor {
        return #colorLiteral(red: 0.9098039216, green: 0.9725490196, blue: 0.8235294118, alpha: 1)
    }
    static var basBlue80: UIColor {
        return #colorLiteral(red: 0.5254901961, green: 0.6862745098, blue: 1, alpha: 1)
    }
    static var basBlue60: UIColor {
        return #colorLiteral(red: 0.6431372549, green: 0.7647058824, blue: 1, alpha: 1)
    }
    static var basBlue50: UIColor {
        return #colorLiteral(red: 0.7058823529, green: 0.8039215686, blue: 1, alpha: 1)
    }
    static var basBlue40: UIColor {
        return #colorLiteral(red: 0.7647058824, green: 0.8431372549, blue: 1, alpha: 1)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }

    convenience init(hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            self.init(red: 0, green: 0, blue: 0)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)

            self.init(
                red: Int((rgbValue >> 16) & 0xFF),
                green: Int((rgbValue >> 8) & 0xFF),
                blue: Int(rgbValue & 0xFF)
            )
        }
    }
}
