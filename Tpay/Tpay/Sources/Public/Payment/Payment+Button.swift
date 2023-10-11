//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Payment {
    
    /// The specialized UIButton designed to serve as an effortless entry point for invoking the payment sheet within your app.
    
    public final class Button: UIButton {
                
        // MARK: - Properties
        
        public override var intrinsicContentSize: CGSize {
            .init(width: super.intrinsicContentSize.width, height: Constants.height)
        }
        
        public override var isHighlighted: Bool {
            didSet {
                guard oldValue != isHighlighted else { return }
                animateGradient(to: gradientColorsForCurrentState())
            }
        }
        
        private lazy var gradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = Constants.normalStateGradientColors
            layer.startPoint = .init(x: 0, y: 0.5)
            layer.endPoint = .init(x: 1, y: 0.5)
            layer.drawsAsynchronously = true
            return layer
        }()

        private lazy var tpayLogo = UIImageView(image: Asset.Icons.tpayLogoDark.image)
        
        // MARK: - Lifecycle
        
        public override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
            setupAppearance()
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            applyGradientLayer()
        }
        
        // MARK: - Overrides
        
        @available(*, unavailable)
        public override func setTitle(_ title: String?, for state: UIControl.State) { }
        
        @available(*, unavailable)
        public override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) { }
                
        // MARK: - Private
        
        private func setupLayout() {
            tpayLogo.layout
                .add(to: self)
                .xAxis.center(with: self)
                .yAxis.center(with: self)
                .activate()
        }
        
        private func setupAppearance() {
            layer.masksToBounds = true
            layer.cornerRadius = 24
        }
        
        private func applyGradientLayer() {
            gradientLayer.frame = bounds
            layer.insertSublayer(gradientLayer, at: 0)
        }
        
        private func animateGradient(to colors: [CGColor]) {
            gradientLayer.removeAllAnimations()
            let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
            animation.delegate = self
            animation.duration = 0.3
            animation.toValue = colors
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            gradientLayer.add(animation, forKey: "colorsChange")
        }
        
        private func gradientColorsForCurrentState() -> [CGColor] {
            isHighlighted ? Constants.highlightedStateGradientColors : Constants.normalStateGradientColors
        }
    }
}

private extension Payment.Button {
    
    enum Constants {
        
        // MARK: - Properties
        
        static let height: CGFloat = 48
        
        static let normalStateGradientColors = [UIColor(red: 41 / 255, green: 82 / 255, blue: 196 / 255, alpha: 1).cgColor,
                                                UIColor(red: 8 / 255, green: 39 / 255, blue: 85 / 255, alpha: 1).cgColor]
        
        static let highlightedStateGradientColors = [UIColor(red: 20 / 255, green: 52 / 255, blue: 142 / 255, alpha: 1).cgColor,
                                                     UIColor(red: 3 / 255, green: 26 / 255, blue: 60 / 255, alpha: 1).cgColor]
    }
}

extension Payment.Button: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        gradientLayer.colors = gradientColorsForCurrentState()
    }
}
