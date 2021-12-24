//
//  AppDelegate.swift
//  BaseProj
//
//  Created by Le Kim Tuan on 29/03/2021.
//

import UIKit

extension UIView {
    class AppGradient: CAGradientLayer {}
    func insertGradient(colors: [UIColor]) {
        removeGradient()
        let gradient = AppGradient()
        gradient.colors = colors.map({ $0.cgColor })
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    func removeGradient() {
        if let gradient = layer.sublayers?.first(where: { $0.isKind(of: AppGradient.self )}) {
            gradient.removeFromSuperlayer()
        }
    }

    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        xOrigin: CGFloat = 0,
        yOrigin: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: xOrigin, height: yOrigin)
        layer.shadowRadius = blur / 2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dxOrigin = -spread
            let rect = bounds.insetBy(dx: dxOrigin, dy: dxOrigin)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    func setQuestionSurveysStyle(borderColor: UIColor) {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor.cgColor
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        xOrigin: CGFloat = 0,
        yOrigin: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xOrigin, height: yOrigin)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxOrigin = -spread
            let rect = bounds.insetBy(dx: dxOrigin, dy: dxOrigin)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    func applySketchShadow(shadow: ShadowStyle) {
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.alpha
        shadowOffset = CGSize(width: shadow.xOrigin, height: shadow.yOrigin)
        shadowRadius = shadow.blur / 2.0
        if shadow.spread == 0 {
            shadowPath = nil
        } else {
            let dxOrigin = -shadow.spread
            let rect = bounds.insetBy(dx: dxOrigin, dy: dxOrigin)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

struct ShadowStyle {
    var color: UIColor = .clear
    var alpha: CFloat = 0
    var xOrigin: CGFloat = 0
    var yOrigin: CGFloat = 0
    var blur: CGFloat = 0
    var spread: CGFloat = 0

    public init(color: UIColor, alpha: CFloat, xOrigin: CGFloat, yOrigin: CGFloat, blur: CGFloat, spread: CGFloat) {
        self.color = color
        self.alpha = alpha
        self.xOrigin = xOrigin
        self.yOrigin = yOrigin
        self.blur = blur
        self.spread = spread
    }
}

extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}

extension UIView {

    public class func loadNib<T: UIView>() -> T {
        let name = String(describing: self)
        let bundle = Bundle(for: T.self)
        guard let xib = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Cannot load nib named \(name)")
        }
        return xib
    }

    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 1, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    func addBorder(edges: [UIRectEdge], borderColor: UIColor?, borderWidth: CGFloat) {
        layer.sublayers?.removeAll(where: { $0.name == "BorderEdge" })
        for edge in edges {
            let border = CALayer()
            border.name = "BorderEdge"
            if edge == .all {
                layer.borderWidth = borderWidth
                layer.borderColor = borderColor?.cgColor
                break
            }
            switch edge {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
            case .bottom:
                border.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.height)
            case .right:
                border.frame = CGRect(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height)
            default:
                break
            }
            border.backgroundColor = borderColor?.cgColor
            layer.addSublayer(border)
        }
        layer.masksToBounds = true
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        layer.mask = mask
    }
}

final class BorderView: UIView {

    var addBorderClosure: (()-> Void)?

    override var bounds: CGRect {
        didSet {
            addBorderClosure?()
        }
    }
}
