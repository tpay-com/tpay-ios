//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithAmbiguousBlikAliasesViewController.ContentView.CollectionView {
    
    final class Cell: UICollectionViewCell {
        
        // MARK: - Properties
        
        private lazy var aliasName = Label.H2.Builder(label: Label.H2()).build()
        
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
            
            aliasName.text = nil
            unsetSelected()
        }
        
        // MARK: - API
        
        func set(blikAlias: Domain.Blik.OneClick.Alias) {
            aliasName.text = blikAlias.application?.name
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            aliasName.layout
                .add(to: self)
                .top.equalTo(self, .top).with(constant: 14)
                .leading.equalTo(self, .leading).with(constant: 14)
                .bottom.equalTo(self, .bottom).with(constant: -14)
                .activate()
            
            radiobox.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing).with(constant: -14)
                .yAxis.center(with: self)
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
