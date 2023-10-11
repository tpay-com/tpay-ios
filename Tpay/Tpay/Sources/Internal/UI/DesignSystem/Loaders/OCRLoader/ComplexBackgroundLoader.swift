//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ComplexBackgroundLoader: UIView {

    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 48, height: 48)
    }
    
    private let loader: Loader
    
    // MARK: - Initializers
    
    init(color: UIColor = .white) {
        loader = Loader(style: .large, color: color)
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupAppearance()
        setupLayout()
    }

    // MARK: - Private
    
    private func setupAppearance() {
        backgroundColor = .Colors.Neutral._900.color.withAlphaComponent(0.5)
        layer.cornerRadius = Constants.radius
        layer.masksToBounds = true
    }
    
    private func setupLayout() {
        loader.layout
            .add(to: self)
            .xAxis.center(with: self)
            .yAxis.center(with: self)
            .activate()
    }
}
