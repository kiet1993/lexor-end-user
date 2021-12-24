//
//  RatingView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 6/3/21.
//

import UIKit

@IBDesignable class RatingView: UIView {
    
    enum Mode: Int {
        case full = 0, half, precise
    }
    
    @IBInspectable var rating: Double = 0 {
        didSet {
            guard oldValue != rating else { return }
            update()
        }
    }
    @IBInspectable var total: Int = 5
    @IBInspectable var modeNumber: Int = 0
    @IBInspectable var spacing: CGFloat = 5.0
    @IBInspectable var fillColor: UIColor = .white
    @IBInspectable var nonFillColor: UIColor = .clear
    @IBInspectable var lineColor: UIColor = .white
    @IBInspectable var lineWidth: CGFloat = 0.5
    
    private var height: CGFloat {
        bounds.height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        update()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        update()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        updateRating(with: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        updateRating(with: touch)
    }
    
    private func updateRating(with touch: UITouch) {
        let x = touch.location(in: self).x
        var touchedRating = getPreciseRating(at: x)
        let mode = Mode(rawValue: modeNumber).unwrapped(or: .precise)
        switch mode {
        case .full: touchedRating = ceil(touchedRating)
        case .half: touchedRating = ceil(touchedRating * 2) / 2
        case .precise: break
        }
        rating = touchedRating
    }
    
    private func getPreciseRating(at x: CGFloat) -> Double {
        if x < 0 { return 0 }
        var xRemainder = x
        var rating = Double(Int(x / (height + spacing)))
        if Int(rating) > total { return Double(total) }
        xRemainder = x.truncatingRemainder(dividingBy: height + spacing)
        if xRemainder > height {
            rating += 1
        } else {
            rating += Double(xRemainder / height)
        }
        return rating
    }
    
    private func update() {
        layer.sublayers = createLayers()
    }
    
    private func createLayers() -> [CALayer] {
        var remainder = min(max(0, Double(total)), rating)
        var layers = [CALayer]()
        for _ in (0..<total) {
            var percent = Double(min(1, max(0, remainder)))
            let mode = Mode(rawValue: modeNumber).unwrapped(or: .precise)
            switch mode {
            case .full: percent = Double(round(percent))
            case .half: percent = Double(round(percent * 2) / 2)
            case .precise: break
            }
            let layer: CALayer
            switch percent {
            case 0: layer = createLayer(isFilled: false)
            case 1: layer = createLayer(isFilled: true)
            default: layer = createPartialLayer(percent: percent)
            }
            layers.append(layer)
            remainder -= 1
        }
        setPosition(layers: layers)
        return layers
    }
    
    private func createLayer(isFilled: Bool) -> CALayer {
        let fillColor: UIColor = isFilled ? self.fillColor : self.nonFillColor
        
        let layer = CALayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = CGPoint()
        layer.masksToBounds = true
        layer.bounds.size = CGSize(width: height, height: height)
        layer.isOpaque = true
        
        let factor = (height - lineWidth) / 100
        let points: [CGPoint] = [
            CGPoint(x: 49.5, y: 0.0),
            CGPoint(x: 60.5, y: 35.0),
            CGPoint(x: 99.0, y: 35.0),
            CGPoint(x: 67.5, y: 58.0),
            CGPoint(x: 78.5, y: 92.0),
            CGPoint(x: 49.5, y: 71.0),
            CGPoint(x: 20.5, y: 92.0),
            CGPoint(x: 31.5, y: 58.0),
            CGPoint(x: 00.0, y: 35.0),
            CGPoint(x: 38.5, y: 35.0)
        ].map {
            CGPoint(
                x: $0.x * CGFloat(factor) + CGFloat(lineWidth / 2),
                y: $0.y * CGFloat(factor) + CGFloat(lineWidth / 2)
            )
        }
        let path = UIBezierPath()
        path.move(to: points[0])
        let remainingPoints = Array(points[1..<points.count])
        for point in remainingPoints {
            path.addLine(to: point)
        }
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.anchorPoint = CGPoint()
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.lineWidth = CGFloat(lineWidth)
        shapeLayer.bounds.size = CGSize(width: height, height: height)
        shapeLayer.masksToBounds = true
        shapeLayer.path = path.cgPath
        shapeLayer.isOpaque = true
        
        layer.addSublayer(shapeLayer)
        
        return layer
    }
    
    private func createPartialLayer(percent: Double) -> CALayer {
        let filledLayer = createLayer(isFilled: true)
        let blankLayer = createLayer(isFilled: false)
        
        let layer = CALayer()
        layer.contentsScale = UIScreen.main.scale
        layer.bounds = CGRect(origin: .zero, size: filledLayer.bounds.size)
        layer.anchorPoint = CGPoint()
        layer.addSublayer(blankLayer)
        layer.addSublayer(filledLayer)
        filledLayer.bounds.size.width *= CGFloat(percent)
        
        return layer
    }
    
    private func setPosition(layers: [CALayer]) {
        for (offset, value) in layers.enumerated() {
            value.position.x = CGFloat(offset) * (height + spacing)
        }
    }
}
