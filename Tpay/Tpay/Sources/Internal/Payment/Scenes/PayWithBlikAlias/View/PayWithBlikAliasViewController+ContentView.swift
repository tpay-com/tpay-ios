//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithBlikAliasViewController {
    
    final class ContentView: UIView, PinnableContentProvider {
        
        // MARK: - Events
        
        var payButtonTapped: Observable<Void> { bottomSection.actionButtonTapped }
        var payByCodeTapped: Observable<Void> { bottomSection.secondaryActionButtonTapped }
        
        // MARK: - Properties
        
        var pinnableContent: PinnableContent { bottomSection }
        var pinnedContentPlaceholder: UIView { bottomSectionPlaceholder }

        private let containerView = UIView()
        
        private lazy var note = Label.Builder(label: .BodySmall())
            .set(text: Strings.payWithBlikAliasNote)
            .set(textAlignment: .center)
            .set(numberOfLines: 0)
            .set(color: .Colors.Neutral._500)
            .build()
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: .empty, withSecondaryAction: true, withGdprNote: true, withRegulationsNote: true))
        private let bottomSectionPlaceholder = UIView()

        // MARK: - API
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
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
        
        // MARK: - PinnableContentProvider
        
        func adjustAfterPinning() {
            fillPinnedContentSpace()
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            bottomSection.set(secondaryButtonTitle: Strings.payWithCode)
        }
        
        private func setupLayout() {
            translatesAutoresizingMaskIntoConstraints = false
            
            containerView.layout
                .add(to: self)
                .top.equalTo(self, .top)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .activate()
            
            note.layout
                .add(to: containerView)
                .top.equalTo(containerView, .top).with(constant: 16)
                .bottom.equalTo(containerView, .bottom)
                .leading.equalTo(containerView, .leading).with(constant: 40)
                .trailing.equalTo(containerView, .trailing).with(constant: -40)
                .activate()
        }
        
        private func fillPinnedContentSpace() {
            bottomSectionPlaceholder.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(containerView, .bottom).with(constant: 16)
                .bottom.equalTo(self, .bottom)
                .height.greaterThanOrEqualTo(pinnableContent, .height)
                .activate()
        }
    }
}
