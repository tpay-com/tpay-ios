//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class TimeIcon: UIView {
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 112, height: 112)
    }
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView(image: Asset.Icons.time.image)
        imageView.tintColor = .Colors.Primary._500.color
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
            .width.equalTo(constant: 30)
            .height.equalTo(constant: 30)
            .xAxis.center(with: self)
            .yAxis.center(with: self)
            .activate()
    }
    
    private func drawOval() {
        let path = UIBezierPath(ovalIn: bounds)
        let oval = CAShapeLayer()
        oval.path = path.cgPath
        oval.fillColor = DesignSystem.Colors.Neutral._100.color.cgColor
        layer.insertSublayer(oval, at: 0)
    }
}
