//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension ChoosePaymentMethodViewController.ContentView.CollectionView {
    
    final class Cell: UICollectionViewCell {
        
        // MARK: - Properties
        
        private lazy var methodName = Label.H2()
        
        private lazy var container: UIStackView = {
            let stackView = UIStackView(arrangeVertically: imageView, methodName)
            stackView.alignment = .leading
            stackView.isUserInteractionEnabled = false
            return stackView
        }()
        
        private let imageView = UIImageView()
        
        override var isSelected: Bool {
            didSet {
                setupColors()
            }
        }
        
        // MARK: - Initializers
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupAppearance()
            setupColors()
            setupLayout()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func prepareForReuse() {
            super.prepareForReuse()
            
            methodName.text = nil
            imageView.image = nil
        }
        
        // MARK: - API
        
        func set(_ method: Domain.PaymentMethod) {
            container.spacing = 4
            methodName.text = method.title
            imageView.image = method.image
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            methodName.isUserInteractionEnabled = false
            methodName.numberOfLines = 1
            layer.cornerRadius = 13
        }
        
        private func setupColors() {
            backgroundColor = isSelected ? .Colors.Primary._500.color : .Colors.Neutral._100.color
            methodName.textColor = isSelected ? .Colors.Neutral.white.color : .Colors.Primary._900.color
            imageView.tintColor = isSelected ? .Colors.Neutral.white.color : .Colors.Primary._500.color
        }
        
        private func setupLayout() {
            container.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .bottom.equalTo(self, .bottom).with(constant: -16)
                .activate()

            layout
                .width.greaterThanOrEqualTo(constant: 122)
                .height.equalTo(constant: 80)
                .activate()
        }
    }
}
