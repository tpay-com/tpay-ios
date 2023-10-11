//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension FailureViewController.ContentView {
    
    final class FailureIcon: UIView {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: 112, height: 112)
        }
        
        private lazy var icon: UIImageView = {
            let imageView = UIImageView(image: Asset.Icons.close.image)
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
                .width.equalTo(constant: 22)
                .height.equalTo(constant: 22)
                .xAxis.center(with: self)
                .yAxis.center(with: self)
                .activate()
        }
        
        private func drawOval() {
            let path = UIBezierPath(ovalIn: bounds)
            let oval = CAShapeLayer()
            oval.path = path.cgPath
            oval.fillColor = DesignSystem.Colors.Semantic.error.color.cgColor
            layer.insertSublayer(oval, at: 0)
        }
    }
}
