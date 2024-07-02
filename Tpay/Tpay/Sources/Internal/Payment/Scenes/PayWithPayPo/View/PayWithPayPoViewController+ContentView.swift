//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

extension PayWithPayPoViewController {
    
    final class ContentView: UIView, PinnableContentProvider {
        
        // MARK: - Events
        
        var payerNameEmitted: Observable<String> { payerName.valueEmitted }
        var payerEmailEmitted: Observable<String> { payerEmail.valueEmitted }
        var payerStreetAddressEmitted: Observable<String> { payerStreetAddress.valueEmitted }
        var payerPostalCodeAddressEmitted: Observable<String> { payerPostalCodeAddress.valueEmitted }
        var payerCityAddressEmitted: Observable<String> { payerCityAddress.valueEmitted }
        
        var payButtonTapped: Observable<Void> { bottomSection.actionButtonTapped }
        
        // MARK: - Properties
        
        var pinnableContent: PinnableContent { bottomSection }
        var pinnedContentPlaceholder: UIView { bottomSectionPlaceholder }
        
        private let heading = Label.Builder(label: .H2())
            .set(text: Strings.payWithPayPoSceneHeadline)
            .build()
        
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
        
        private lazy var payerStreetAddress: TextInput = {
            let textField = TextField()
            textField.textContentType = .fullStreetAddress
            
            let textInput = TextInput(textField: textField)
            textInput.placeholder = Strings.payPoPayerStreetAddress
            
            return textInput
        }()
        
        private lazy var payerPostalCodeAddress: TextInput = {
            let textField = TextField.PostalCode()
            let textInput = TextInput(textField: textField)
            textInput.placeholder = Strings.payPoPayerPostalCodeAddress
            
            return textInput
        }()
        
        private lazy var payerCityAddress: TextInput = {
            let textField = TextField()
            textField.textContentType = .addressCity
            
            let textInput = TextInput(textField: textField)
            textInput.placeholder = Strings.payPoPayerCityAddress
            
            return textInput
        }()
        
        private lazy var payerCountryAddress: TextInput = {
            let options = [Strings.countriesPoland] // Poland region is the only possibilty for PayPo according to the requirements.
            let textField = TextField.Country(with: options)            
            let textInput = TextInput(textField: textField)
            textInput.placeholder = Strings.payPoPayerCountryAddress
            textInput.text = options.first
            
            return textInput
        }()
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: Strings.payWithPayPoSceneActionButtonTitle,
                                                              withSecondaryAction: false,
                                                              withGdprNote: true,
                                                              withRegulationsNote: true))
        
        private let bottomSectionPlaceholder = UIView()
        
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
            setupActions()
        }
        
        // MARK: - API
        
        func set(initialPayerName: String?) {
            payerName.text = initialPayerName
        }
        
        func set(initialPayerEmail: String?) {
            payerEmail.text = initialPayerEmail
        }
        
        func set(initialPayerStreetAddress: String?) {
            payerStreetAddress.text = initialPayerStreetAddress
        }
        
        func set(initialPayerPostalCodeAddress: String?) {
            payerPostalCodeAddress.text = initialPayerPostalCodeAddress
        }
        
        func set(initialPayerCityAddress: String?) {
            payerCityAddress.text = initialPayerCityAddress
        }
        
        func set(payerNameState: InputContentState) {
            payerName.set(inputContentState: payerNameState)
        }
        
        func set(payerEmailState: InputContentState) {
            payerEmail.set(inputContentState: payerEmailState)
        }
        
        func set(payerStreetAddressState: InputContentState) {
            payerStreetAddress.set(inputContentState: payerStreetAddressState)
        }
        
        func set(payerPostalCodeAddressState: InputContentState) {
            payerPostalCodeAddress.set(inputContentState: payerPostalCodeAddressState)
        }
        
        func set(payerCityAddressState: InputContentState) {
            payerCityAddress.set(inputContentState: payerCityAddressState)
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
            
            heading.layout
                .add(to: self)
                .top.equalTo(self, .top)
                .leading.equalTo(self, .leading).with(constant: 24)
                .trailing.greaterThanOrEqualTo(self, .trailing).with(constant: -24)
                .activate()
            
            payerName.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(heading, .bottom).with(constant: 16)
                .activate()
            
            payerEmail.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(payerName, .bottom).with(constant: 8)
                .activate()
            
            payerStreetAddress.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(payerEmail, .bottom).with(constant: 8)
                .activate()
            
            let postalCodeCityContainer = UIStackView(arrangeHorizontally: payerPostalCodeAddress, payerCityAddress)
            postalCodeCityContainer.distribution = .fillEqually
            postalCodeCityContainer.alignment = .firstBaseline
            
            postalCodeCityContainer.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(payerStreetAddress, .bottom).with(constant: 8)
                .activate()
            
            payerCountryAddress.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .top.equalTo(postalCodeCityContainer, .bottom).with(constant: 8)
                .activate()
        }
        
        private func setupActions() {
        }
        
        private func fillPinnedContentSpace() {
            bottomSectionPlaceholder.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(payerCountryAddress, .bottom).with(constant: 16)
                .bottom.equalTo(self, .bottom)
                .height.greaterThanOrEqualTo(pinnableContent, .height)
                .activate()
        }
    }
}
