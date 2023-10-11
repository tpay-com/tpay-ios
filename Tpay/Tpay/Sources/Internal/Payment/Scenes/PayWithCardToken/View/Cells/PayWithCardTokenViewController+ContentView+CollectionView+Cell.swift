//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithCardTokenViewController.ContentView.CollectionView {
    
    final class Cell: UICollectionViewCell {
        
        // MARK: - Properties
                
        private let brandLogo: CardBrandView = {
            let view = CardBrandView(brandImage: .init())
            view.setContentHuggingPriority(.required, for: .horizontal)
            return view
        }()
        
        private lazy var labelsContainer: UIView = {
            let stackView = UIStackView(arrangeVertically: brandName, cardNumber)
            stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            stackView.spacing = 0
            return stackView
        }()
                
        private lazy var brandName = Label.H2.Builder(label: Label.H2())
            .build()
        
        private lazy var cardNumber = Label.Body.Builder(label: Label.Body())
            .build()
        
        private let radiobox: Button.Radiobox = {
            let radiobox = Button.Radiobox()
            radiobox.setContentHuggingPriority(.required, for: .horizontal)
            radiobox.isUserInteractionEnabled = false
            return radiobox
        }()
        
        override var isSelected: Bool {
            didSet {
                updateAppearance()
            }
        }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
            setupAppearance()
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            
            brandLogo.set(brandImage: .init())
            brandName.text = nil
            cardNumber.text = nil
            unsetSelected()
        }
        
        // MARK: - API
        
        func set(cardToken: Domain.CardToken) {
            brandLogo.set(brand: cardToken.brand)
            brandName.text = cardToken.brand.rawValue
            cardNumber.text = "**** \(cardToken.cardTail)"
        }
                
        // MARK: - Private
        
        private func setupLayout() {
            brandLogo.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 14)
                .yAxis.center(with: self)
                .activate()
            
            radiobox.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing).with(constant: -14)
                .yAxis.center(with: self)
                .activate()
            
            labelsContainer.layout
                .add(to: self)
                .leading.equalTo(brandLogo, .trailing).with(constant: 16)
                .trailing.equalTo(radiobox, .leading).with(constant: -16)
                .top.equalTo(self, .top).with(constant: 12)
                .bottom.equalTo(self, .bottom).with(constant: -12)
                .activate()
        }
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral._100.color
            
            layer.masksToBounds = true
            layer.cornerRadius = 13
            layer.borderColor = Asset.Colors.Primary._500.color.cgColor
        }
        
        private func updateAppearance() {
            isSelected ? setSelected() : unsetSelected()
        }
        
        private func setSelected() {
            radiobox.isSelected = true
            layer.borderWidth = 2
        }
        
        private func unsetSelected() {
            radiobox.isSelected = false
            layer.borderWidth = 0
        }
        
        // MARK: - Overrides
        
        override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
                super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        }
    }
}
