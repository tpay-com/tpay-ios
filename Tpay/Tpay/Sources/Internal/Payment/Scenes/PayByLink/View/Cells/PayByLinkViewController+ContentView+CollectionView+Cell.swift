//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayByLinkViewController.ContentView.CollectionView {
    
    final class Cell: UICollectionViewCell {
        
        // MARK: - Properties

        private lazy var bankImage = UIImageView()
        private lazy var bankLabel = Label.H2()
        private lazy var container = UIStackView(arrangedSubviews: [bankLabel])
        
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
            setupComponents()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            
            bankLabel.text = nil
            bankLabel.isHidden = false
            bankImage.image = nil
            unsetSelected()
        }
        
        // MARK: - API
        
        func set(bank: Domain.PaymentMethod.Bank) {
            bankLabel.text = bank.name
            bankLabel.isHidden = false
            
            guard let url = bank.imageUrl else { return }
            bankImage.remoteImageProvider.setImage(with: url, completion: handleImageSetting)
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            container.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 8)
                .trailing.equalTo(self, .trailing).with(constant: -8)
                .top.equalTo(self, .top).with(priority: .defaultHigh)
                .bottom.equalTo(self, .bottom).with(priority: .defaultHigh)
                .height.equalTo(constant: 80)
                .activate()
            
            bankImage.layout
                .add(to: self)
                .leading.equalTo(container, .leading).with(constant: 16)
                .trailing.equalTo(container, .trailing).with(constant: -16)
                .top.equalTo(container, .top).with(constant: 16)
                .bottom.equalTo(container, .bottom).with(constant: -16)
                .activate()
        }
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral.white.color
            
            layer.borderWidth = 1
            layer.masksToBounds = true
            layer.cornerRadius = 13
            layer.borderColor = Asset.Colors.Neutral._200.color.cgColor
        }
        
        private func setupComponents() {
            bankLabel.numberOfLines = 2
            bankLabel.adjustsFontSizeToFitWidth = true
            bankLabel.minimumScaleFactor = 0.5
            bankLabel.textAlignment = .center
            
            bankImage.contentMode = .scaleAspectFit
        }
        
        private func updateAppearance() {
            isSelected ? setSelected() : unsetSelected()
        }
        
        private func setSelected() {
            layer.borderWidth = 2
            layer.borderColor = Asset.Colors.Primary._500.color.cgColor
        }
        
        private func unsetSelected() {
            layer.borderWidth = 1
            layer.borderColor = Asset.Colors.Neutral._200.color.cgColor
        }
        
        private func handleImageSetting(_ result: Result<RemoteImageProvider.Source, Error>) {
            guard case .success = result else { return }
            bankLabel.isHidden = true
        }
        
        // MARK: - Overrides
        
        override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                              withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                              verticalFittingPriority: UILayoutPriority) -> CGSize {
            super.systemLayoutSizeFitting(targetSize,
                                          withHorizontalFittingPriority: .required,
                                          verticalFittingPriority: .fittingSizeLevel)
        }
    }
}
