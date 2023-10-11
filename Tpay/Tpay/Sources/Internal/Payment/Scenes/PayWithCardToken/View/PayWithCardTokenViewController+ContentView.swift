//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithCardTokenViewController {
    
    final class ContentView: UIView, PinnableContentProvider {
        
        // MARK: - Events
        
        var addCardButtonTapped: Observable<Void> { addCardButton.tap }
        var payButtonTapped: Observable<Void> { bottomSection.actionButtonTapped }
        
        // MARK: - Properties
        
        var pinnableContent: PinnableContent { bottomSection }
        var pinnedContentPlaceholder: UIView { bottomSectionPlaceholder }
        
        private let heading = Label.Builder(label: .H2())
            .set(text: Strings.payWithCardTokenHeadline)
            .build()
        
        private let addCardButton: UIButton = {
            let button = UIButton.Builder(button: Button.Secondary.AddButton(text: Strings.addCard))
                .build()
            button.setContentHuggingPriority(.required, for: .horizontal)
            return button
        }()
        
        private(set) lazy var collectionView = CollectionView()
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: .empty, withSecondaryAction: false, withGdprNote: true, withRegulationsNote: true))
        private let bottomSectionPlaceholder = UIView()
        
        private lazy var collectionViewHeightContraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupActions()
            setupLayout()
        }
        
        // MARK: - API
        
        func set(transaction: Domain.Transaction) {
            bottomSection.set(amount: transaction.paymentInfo.amount)
        }
        
        func selectCardToken(at indexPath: IndexPath) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        }
        
        func set(isProcessing: Bool) {
            bottomSection.set(isProcessing: isProcessing)
        }
        
        // MARK: - PinnableContentProvider
        
        func adjustAfterPinning() {
            fillPinnedContentSpace()
        }
        
        // MARK: - Private

        private func setupLayout() {
            translatesAutoresizingMaskIntoConstraints = false
            
            addCardButton.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(self, .top)
                .activate()
                        
            heading.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 24)
                .trailing.greaterThanOrEqualTo(addCardButton, .leading).with(constant: -8)
                .yAxis.center(with: addCardButton)
                .activate()
            
            collectionView.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(addCardButton, .bottom).with(constant: 16)
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
