//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension PayWithDigitalWalletViewController {
    
    final class ContentView: UIView, PinnableContentProvider {
        
        // MARK: - Events
        
        var payButtonTapped: Observable<Void> { bottomSection.actionButtonTapped }
        
        // MARK: - Properties
        
        var pinnableContent: PinnableContent { bottomSection }
        var pinnedContentPlaceholder: UIView { bottomSectionPlaceholder }
        
        private lazy var headerContainer: UIView = {
            let arrangedSubviews: [UIView] = [exclamationIcon, heading]
            let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.alignment = .center
            return stackView
        }()
        
        private lazy var exclamationIcon: UIImageView = {
            let imageView = UIImageView(image: DesignSystem.Icons.exclamation.image)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private let heading = Label.Builder(label: .H2())
            .set(text: Strings.payWithHeadline)
            .build()
        
        private(set) lazy var collectionView = CollectionView()
        private lazy var collectionViewHeightContraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: .empty,
                                                              withSecondaryAction: false,
                                                              withGdprNote: true,
                                                              withRegulationsNote: true))
        private let bottomSectionPlaceholder = UIView()
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupActions()
            setupAppearance()
            setupLayout()
        }
        
        // MARK: - API
        
        func set(transaction: Domain.Transaction) {
            bottomSection.set(amount: transaction.paymentInfo.amount)
        }
        
        func set(isProcessing: Bool) {
            bottomSection.set(isProcessing: isProcessing)
        }
        
        func set(isValid: Bool) {
            if isValid {
                heading.textColor = DesignSystem.Colors.Primary._900.color
                exclamationIcon.hide()
            } else {
                heading.textColor = DesignSystem.Colors.Semantic.error.color
                exclamationIcon.show()
            }
        }
        
        func preselectFirstItem() {
            collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        }
        
        // MARK: - PinnableContentProvider
        
        func adjustAfterPinning() {
            fillPinnedContentSpace()
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            exclamationIcon.hide()
        }
        
        private func setupLayout() {
            translatesAutoresizingMaskIntoConstraints = false
            
            headerContainer.layout
                .add(to: self)
                .top.equalTo(self, .top)
                .leading.equalTo(self, .leading).with(constant: 24)
                .trailing.greaterThanOrEqualTo(self, .trailing).with(constant: -24)
                .activate()
            
            exclamationIcon.layout
                .height.equalTo(constant: 16)
                .width.equalTo(exclamationIcon, .height)
                .activate()
            
            collectionView.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(headerContainer, .bottom).with(constant: 16)
                .activate()
            
            NSLayoutConstraint.activate([collectionViewHeightContraint])
        }
        
        private func setupActions() {
            collectionView.contentSizeObservable
                .subscribe(onNext: { [weak self] contentSize in self?.updateCollectionViewHeight(with: contentSize.height) })
                .add(to: disposer)
        }
        
        private func updateCollectionViewHeight(with height: CGFloat) {
            collectionViewHeightContraint.constant = height
        }
        
        private func fillPinnedContentSpace() {
            bottomSectionPlaceholder.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(collectionView, .bottom).with(constant: 16)
                .bottom.equalTo(self, .bottom)
                .height.greaterThanOrEqualTo(pinnableContent, .height)
                .activate()
        }
    }
}
