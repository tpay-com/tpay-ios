//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithCardViewController {
    
    final class ContentView: UIView, PinnableContentProvider {
        
        // MARK: - Events

        var payButtonTapped: Observable<Void> { bottomSection.actionButtonTapped }
        var cardNumberEmitted: Observable<String> { cardNumber.valueEmitted }
        var cardExpiryDateEmitted: Observable<String> { cardExpiryDate.valueEmitted }
        var cardSecurityCodeEmitted: Observable<String> { cardSecurityCode.valueEmitted }
        var cardSecurityCodeReset: Observable<Void> { cardSecurityCode.onValueReset }
        
        var saveCardSelectionChanged: Observable<Bool> { saveCardCheckbox.selectionChanged }
        var ocrButtonTapped: Observable<Void> { cardNumberTextField.ocrButtonTapped }
        
        var navigateToOneClickButtonTapped: Observable<Void> { navigateToOneClickButton.tap }
        
        // MARK: - Properties
        
        var pinnableContent: PinnableContent { bottomSection }
        var pinnedContentPlaceholder: UIView { bottomSectionPlaceholder }
        
        private let isNavigationToOneClickEnabled: Bool
        
        private let headerContainer = UIView()
        
        private lazy var heading = Label.Builder(label: .H2())
            .set(text: Strings.payWithCardHeadline)
            .build()
                
        private lazy var navigateToOneClickButton = UIButton.Builder(button: Button.Secondary.BackButton(text: Strings.navigateToCardSelection))
            .build()
                
        private let cardNumberTextField = TextField.CardNumber()
        private let cardSecurityCodeTextField = TextField.CVC()
                
        private lazy var cardNumber: TextInput = {
            let input = TextInput(textField: cardNumberTextField)
            input.placeholder = Strings.cardNumber
            return input
        }()
        
        private lazy var cardExpiryDate = ExpiryDateInput()
        
        private lazy var cardSecurityCode: TextInput = {
            let textField = cardSecurityCodeTextField
            let input = TextInput(textField: textField)
            input.placeholder = Strings.cardSecurityCode
            return input
        }()
        
        private let saveCardNote = Label.Builder(label: .BodySmall())
            .set(text: Strings.saveCardNote)
            .set(color: .Colors.Neutral._500)
            .set(numberOfLines: 0)
            .set(isUserInteractionEnabled: true)
            .build()
        
        private let saveCardCheckbox: Button.Checkbox = {
            let checkbox = Button.Checkbox()
            checkbox.setContentHuggingPriority(.required, for: .horizontal)
            return checkbox
        }()
        
        private let merchantGdprNote = TextView()
        
        private let partners = Partners()
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: .empty,
                                                              withSecondaryAction: false,
                                                              withGdprNote: true,
                                                              withRegulationsNote: true))
        private let bottomSectionPlaceholder = UIView()
        
        // MARK: - Initializers
        
        init(isNavigationToOneClickEnabled: Bool = false) {
            self.isNavigationToOneClickEnabled = isNavigationToOneClickEnabled
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupLayout()
            setupHeaderLayout()
            
            setupActions()
        }
        
        // MARK: - API
        
        func set(transaction: Domain.Transaction) {
            bottomSection.set(amount: transaction.paymentInfo.amount)
        }
        
        func set(cardNumberState: InputContentState) {
            cardNumber.set(inputContentState: cardNumberState)
        }
        
        func set(cardExpiryDateState: InputContentState) {
            cardExpiryDate.set(inputContentState: cardExpiryDateState)
        }
        
        func set(cardSecurityCodeState: InputContentState) {
            cardSecurityCode.set(inputContentState: cardSecurityCodeState)
        }
        
        func set(cardBrand: CardNumberDetectionModels.CreditCard.Brand?) {
            guard let cardBrand = cardBrand else {
                cardNumberTextField.set(cardBrand: nil)
                return
            }
            
            let brand = Domain.CardToken.Brand.make(from: cardBrand)
            cardNumberTextField.set(cardBrand: brand)
            
            if cardNumber.text.value(or: .empty).isNotEmpty && cardExpiryDate.text.value(or: .empty).isNotEmpty {
                _ = cardSecurityCode.becomeFirstResponder()
            } else if cardNumber.text.value(or: .empty).isNotEmpty {
                _ = cardExpiryDate.becomeFirstResponder()
            }
        }
        
        func set(cardData: CardNumberDetectionModels.CreditCard) {
            cardNumber.text = cardData.number
            cardExpiryDate.text = cardData.expiryDate

            set(cardBrand: cardData.brand)
        }
        
        func set(merchantDetails: Domain.MerchantDetails) {
            merchantGdprNote.setText(asHtml: merchantDetails.merchantGdprNote)
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
            
            headerContainer.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 24)
                .trailing.equalTo(self, .trailing).with(constant: -24)
                .top.equalTo(self, .top).with(constant: 16)
                .activate()
            
            cardNumber.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(headerContainer, .bottom).with(constant: 8)
                .activate()

            cardExpiryDate.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .top.equalTo(cardNumber, .bottom).with(constant: 16)
                .activate()

            cardSecurityCode.layout
                .add(to: self)
                .leading.equalTo(cardExpiryDate, .trailing).with(constant: 8)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(cardExpiryDate, .top)
                .width.equalTo(cardExpiryDate, .width)
                .activate()

            saveCardNote.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 24)
                .top.equalTo(cardSecurityCode, .bottom).with(constant: 16)
                .activate()

            saveCardCheckbox.layout
                .add(to: self)
                .leading.equalTo(saveCardNote, .trailing).with(constant: 8)
                .trailing.equalTo(self, .trailing).with(constant: -24)
                .yAxis.center(with: saveCardNote)
                .activate()

            merchantGdprNote.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 24)
                .trailing.equalTo(saveCardCheckbox, .leading)
                .top.equalTo(saveCardNote, .bottom).with(constant: 8)
                .activate()
            
            partners.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 24)
                .top.equalTo(merchantGdprNote, .bottom).with(constant: 32)
                .activate()
        }
        
        private func setupHeaderLayout() {
            isNavigationToOneClickEnabled ? setupHeaderLayoutWithNavigationItem() : setupHeaderLayoutWithTitle()
        }

        private func setupHeaderLayoutWithNavigationItem() {
            navigateToOneClickButton.layout
                .add(to: headerContainer)
                .leading.equalTo(headerContainer, .leading)
                .top.equalTo(headerContainer, .top)
                .bottom.equalTo(headerContainer, .bottom)
                .activate()
        }
        
        private func setupHeaderLayoutWithTitle() {
            heading.layout
                .add(to: headerContainer)
                .leading.equalTo(headerContainer, .leading)
                .top.equalTo(headerContainer, .top)
                .bottom.equalTo(headerContainer, .bottom).with(constant: -8)
                .activate()
        }
        
        private func setupActions() {
            saveCardNote.tap
                .subscribe(onNext: { [weak self] in self?.saveCardCheckbox.toggleSelection() })
                .add(to: disposer)
        }
        
        private func fillPinnedContentSpace() {
            bottomSectionPlaceholder.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(partners, .bottom).with(constant: 16)
                .bottom.equalTo(self, .bottom)
                .height.greaterThanOrEqualTo(pinnableContent, .height)
                .activate()
        }
    }
}

private extension Domain.CardToken.Brand {
    
    static func make(from brand: CardNumberDetectionModels.CreditCard.Brand) -> Self {
        switch brand {
        case .mastercard:
            return .mastercard
        case .visa:
            return .visa
        default:
            return .other(.empty)
        }
    }
}
