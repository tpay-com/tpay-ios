//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController.LanguageSwitch {
    
    final class Accessory: UIView {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: 24, height: 16)
        }
        
        private let containerView = UIView()
        private let rightArrow: UIImageView = UIImageView(image: Asset.Icons.rightArrow.image)
        
        // MARK: - Initilizers
        
        init() {
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
            setupAppearance()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            containerView.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(self, .top)
                .bottom.equalTo(self, .bottom)
                .activate()
            
            rightArrow.layout
                .add(to: containerView)
                .leading.equalTo(containerView, .leading)
                .trailing.equalTo(containerView, .trailing).with(constant: -8)
                .height.equalTo(constant: 12)
                .yAxis.center(with: self)
                .activate()
        }
        
        private func setupAppearance() {
            rightArrow.tintColor = .Colors.Primary._500.color
            rightArrow.contentMode = .scaleAspectFit
        }
    }
}
