//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension AddCardViewController {
    
    final class ContentView: UIScrollView {
        
        // MARK: - Events
        
        var saveButtonTapped: Observable<Void> { bottomSection.actionButtonTapped }
        var ocrButtonTapped: Observable<Void> { cardNumberTextField.ocrButtonTapped }
        var payerNameEmitted: Observable<String> { payerName.valueEmitted }
        var payerEmailEmitted: Observable<String> { payerEmail.valueEmitted }
        var cardNumberEmitted: Observable<String> { cardNumber.valueEmitted }
        var cardExpiryDateEmitted: Observable<String> { cardExpiryDate.valueEmitted }
        var cardSecurityCodeEmitted: Observable<String> { cardSecurityCode.valueEmitted }
        var cardSecurityCodeReset: Observable<Void> { cardSecurityCode.onValueReset }
        
        // MARK: - Properties
        
        private let container = UIView()
        
        private lazy var payerName: TextInput = {
            let textField = TextField()
            textField.textContentType = .name
            textField.keyboardType = .namePhonePad
            
            let textInput = TextInput(textField: textField)
            textInput.placeholder = Strings.payerName
            
            return textInput
        }()
        
        private lazy var payerEmail: TextInput = {
            let textField = TextField()
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
            
            let textInput = TextInput(textField: textField)
            textInput.placeholder = Strings.payerEmail
            
            return textInput
        }()
        
        private let cardNumberTextField = TextField.CardNumber()
        private let cardSecurityCodeTextField = TextField.CVC()
                
        private lazy var cardNumber: TextInput = {
            let input = TextInput(textField: cardNumberTextField)
            input.placeholder = Strings.cardNumber
            return input
        }()
        
        private lazy var cardExpiryDate: TextInput = {
            let textField = TextField.ExpiryDate()
            let input = TextInput(textField: textField)
            input.placeholder = Strings.cardExpiryDate
            return input
        }()
        
        private lazy var cardSecurityCode: TextInput = {
            let textField = cardSecurityCodeTextField
            let input = TextInput(textField: textField)
            input.placeholder = Strings.cardSecurityCode
            return input
        }()
        
        private let merchantGdprNote = TextView()
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: Strings.addCardSave,
                                                              withSecondaryAction: false,
                                                              withGdprNote: true,
                                                              withRegulationsNote: false))
        private let bottomSectionPlaceholder = UIView()
        private let bottomSectionLogo = BottomSection.Logo()
        
        // MARK: - Initializers
        
        init() {
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupLayout()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            recalculateShading()
        }
        
        // MARK: - API
        
        func set(initialPayerName: String?) {
            payerName.text = initialPayerName
        }
        
        func set(initialPayerEmail: String?) {
            payerEmail.text = initialPayerEmail
        }
        
        func set(payerNameState: InputContentState) {
            payerName.set(inputContentState: payerNameState)
        }
        
        func set(payerEmailState: InputContentState) {
            payerEmail.set(inputContentState: payerEmailState)
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
        
        // MARK: - Private
        
        private func setupLayout() {
            translatesAutoresizingMaskIntoConstraints = false
            
            container.layout
                .add(to: self)
                .leading.equalTo(safeAreaLayoutGuide, .leading)
                .trailing.equalTo(safeAreaLayoutGuide, .trailing)
                .top.equalTo(self, .top)
                .bottom.equalTo(self, .bottom)
                .xAxis.center(with: self).with(priority: .defaultLow)
                .yAxis.center(with: self).with(priority: .defaultLow)
                .height.greaterThanOrEqualTo(self, .height)
                .activate()
            
            payerName.layout
                .add(to: container)
                .leading.equalTo(container, .leading).with(constant: 16)
                .trailing.equalTo(container, .trailing).with(constant: -16)
                .top.equalTo(container, .top)
                .activate()
            
            payerEmail.layout
                .add(to: container)
                .leading.equalTo(container, .leading).with(constant: 16)
                .trailing.equalTo(container, .trailing).with(constant: -16)
                .top.equalTo(payerName, .bottom).with(constant: 8)
                .activate()
            
            cardNumber.layout
                .add(to: container)
                .leading.equalTo(container, .leading).with(constant: 16)
                .trailing.equalTo(container, .trailing).with(constant: -16)
                .top.equalTo(payerEmail, .bottom).with(constant: 8)
                .activate()

            cardExpiryDate.layout
                .add(to: container)
                .leading.equalTo(container, .leading).with(constant: 16)
                .top.equalTo(cardNumber, .bottom).with(constant: 16)
                .activate()

            cardSecurityCode.layout
                .add(to: container)
                .leading.equalTo(cardExpiryDate, .trailing).with(constant: 8)
                .trailing.equalTo(container, .trailing).with(constant: -16)
                .top.equalTo(cardExpiryDate, .top)
                .width.equalTo(cardExpiryDate, .width)
                .activate()
            
            bottomSection.layout
                .add(to: self)
                .width.equalTo(self, .width)
                .xAxis.center(with: self)
                .bottom.equalTo(safeAreaLayoutGuide, .bottom)
                .activate()
            
            bottomSectionPlaceholder.layout
                .add(to: container)
                .leading.equalTo(container, .leading)
                .trailing.equalTo(container, .trailing)
                .top.equalTo(cardSecurityCode, .bottom).with(constant: 16)
                .bottom.equalTo(container, .bottom)
                .height.greaterThanOrEqualTo(bottomSection, .height)
                .activate()
            
            bottomSectionLogo.layout
                .add(to: self)
                .leading.equalTo(container, .leading).with(constant: 16)
                .trailing.equalTo(container, .trailing).with(constant: -16)
                .bottom.equalTo(bottomSection, .top)
                .activate()
        }
        
        private func recalculateShading() {
            let bottomSectionLogoYPosition = convert(bottomSectionLogo.frame.origin, to: container).y
            let distanceToPlaceholder = bottomSectionLogoYPosition - bottomSectionPlaceholder.frame.minY
            guard distanceToPlaceholder > -8 else {
                shade()
                return
            }
            removeShade()
        }
        
        private func shade() {
            bottomSection.shade()
            bottomSectionLogo.fadeOut()
        }
        
        private func removeShade() {
            bottomSection.removeShade()
            bottomSectionLogo.fadeIn()
        }
    }
}
extension AddCardViewController.ContentView: SheetAppearanceAware {
    
    func adjust(for appearance: SheetViewController.ContentView.Appearance) {
        recalculateShading()
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
