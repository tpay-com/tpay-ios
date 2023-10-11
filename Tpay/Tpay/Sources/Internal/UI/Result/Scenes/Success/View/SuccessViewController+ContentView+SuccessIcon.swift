//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SuccessViewController.ContentView {
    
    final class SuccessIcon: UIView {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: 112, height: 112)
        }
        
        private lazy var icon: UIImageView = {
            let imageView = UIImageView(image: Asset.Icons.check.image)
            imageView.tintColor = .Colors.Neutral.white.color
            return imageView
        }()
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            drawOval()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            icon.layout
                .add(to: self)
                .width.equalTo(constant: 25)
                .height.equalTo(constant: 20)
                .xAxis.center(with: self)
                .yAxis.center(with: self)
                .activate()
        }
        
        private func drawOval() {
            let path = UIBezierPath(ovalIn: bounds)
            let oval = CAShapeLayer()
            oval.path = path.cgPath
            oval.fillColor = DesignSystem.Colors.Semantic.success.color.cgColor
            layer.insertSublayer(oval, at: 0)
        }
    }
}
