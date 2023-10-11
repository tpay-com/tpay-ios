//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension PayWithDigitalWalletViewController.ContentView.CollectionView {
    
    final class Cell: UICollectionViewCell {
        
        // MARK: - Properties
        
        private let walletLogoView = UIImageView()
        
        private lazy var walletName = Label.H2.Builder(label: Label.H2())
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
            
            walletLogoView.image = nil
            walletName.text = nil
            unsetSelected()
        }
        
        // MARK: - API
        
        func set(digitalWallet: Domain.PaymentMethod.DigitalWallet) {
            walletName.text = digitalWallet.name
            guard let url = digitalWallet.imageUrl else { return }
            walletLogoView.remoteImageProvider.setImage(with: url, completion: handleImageSetting)
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            walletLogoView.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 14)
                .yAxis.center(with: self)
                .width.equalTo(constant: 35)
                .height.equalTo(constant: 24)
                .activate()
            
            radiobox.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing).with(constant: -14)
                .yAxis.center(with: self)
                .activate()
            
            walletName.layout
                .add(to: self)
                .leading.equalTo(walletLogoView, .trailing).with(constant: 16)
                .trailing.equalTo(radiobox, .leading).with(constant: -16)
                .top.equalTo(self, .top).with(constant: 14)
                .bottom.equalTo(self, .bottom).with(constant: -14)
                .activate()
        }
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral._100.color
            
            layer.masksToBounds = true
            layer.cornerRadius = 13
            layer.borderColor = Asset.Colors.Primary._500.color.cgColor
            
            walletLogoView.contentMode = .scaleAspectFit
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
        
        private func handleImageSetting(_ result: Result<RemoteImageProvider.Source, Error>) {
            guard case .failure = result else { return }
            walletLogoView.isHidden = true
        }
        
        // MARK: - Overrides
        
        override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
                super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        }
    }
}
