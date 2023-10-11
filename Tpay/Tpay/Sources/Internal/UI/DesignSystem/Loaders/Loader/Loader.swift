//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class Loader: UIView {

    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        .init(width: style.size.width, height: style.size.height)
    }
    
    private let color: UIColor
    private let style: Loader.Style
    
    private let rotationAnimationKey = "rotationAnimation"
    private var rotationAnimation: CABasicAnimation = {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        return rotation
    }()
    
    // MARK: - Initializers
    
    init(style: Loader.Style, color: UIColor = .white) {
        self.style = style
        self.color = color
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupAppearance()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawLoaderLine()
    }
    
    // MARK: - API
    
    func startAnimation() {
        self.layer.add(rotationAnimation, forKey: rotationAnimationKey)
    }
    
    func stopAnimation() {
        self.layer.removeAnimation(forKey: rotationAnimationKey)
    }

    // MARK: - Private
    
    private func setupAppearance() {
        backgroundColor = .clear
    }
    
    private func drawLoaderLine() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (style.size.height / 2) - (Constants.lineWidth / 2)
        var startAngle: CGFloat = 0
        for angle in 1...360 {
            let endAngle = CGFloat(angle) / 180 * .pi
            let path = UIBezierPath(arcCenter: center,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
            path.lineWidth = Constants.lineWidth
            startAngle = endAngle
            color.withAlphaComponent(CGFloat(angle) / 360).set()
            path.stroke()
        }
    }
}
