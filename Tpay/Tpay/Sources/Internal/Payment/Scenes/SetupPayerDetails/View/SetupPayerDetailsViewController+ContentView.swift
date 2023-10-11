//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SetupPayerDetailsViewController {
    
    final class ContentView: UIScrollView {
        
        // MARK: - Events
        
        var payerNameEmitted: Observable<String> { payerName.valueEmitted }
        var payerEmailEmitted: Observable<String> { payerEmail.valueEmitted }
        
        var choosePaymentMethodTapped: Observable<Void> { bottomSection.actionButtonTapped }
        
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
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: Strings.choosePaymentMethod, withSecondaryAction: false, withGdprNote: true, withRegulationsNote: false))
        private let bottomSectionPlaceholder = UIView()
        private let bottomSectionLogo = BottomSection.Logo()
        
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
                .top.equalTo(payerEmail, .bottom).with(constant: 16)
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

extension SetupPayerDetailsViewController.ContentView: SheetAppearanceAware {
    
    func adjust(for appearance: SheetViewController.ContentView.Appearance) {
        recalculateShading()
    }
}
