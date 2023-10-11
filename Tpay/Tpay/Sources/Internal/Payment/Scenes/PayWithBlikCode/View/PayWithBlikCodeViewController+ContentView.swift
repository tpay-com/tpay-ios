//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithBlikCodeViewController {
    
    final class ContentView: UIView, PinnableContentProvider {
        
        // MARK: - Events

        var payButtonTapped: Observable<Void> { bottomSection.actionButtonTapped }
        var blikCodeEmitted: Observable<String> { blikCode.valueEmitted }
        var navigateToAliasesButtonTapped: Observable<Void> { navigateToAliasesButton.tap }
        
        var registerAliasSelectionChanged: Observable<Bool> { registerAliasCheckbox.selectionChanged }
        var aliasLabelEmitted: Observable<String> { aliasLabel.valueEmitted }
        
        // MARK: - Properties
        
        var pinnableContent: PinnableContent { bottomSection }
        var pinnedContentPlaceholder: UIView { bottomSectionPlaceholder }
        
        private let isNavigationToAliasesEnabled: Bool
        
        private lazy var navigateToAliasesButton = UIButton.Builder(button: Button.Secondary.BackButton(text: Strings.back))
            .build()
        
        private lazy var blikCode: TextInput = {
            let textField = TextField.Blik()
            let input = TextInput(textField: textField)
            input.placeholder = Strings.blikCode
            return input
        }()
        
        private lazy var aliasRegistrationSection: UIView = {
            let stackView = UIStackView(arrangeVertically: registerAliasCheckboxContainer, aliasLabel)
            stackView.alignment = .center
            return stackView
        }()
        
        private lazy var registerAliasCheckboxContainer: UIView = {
            let stackView = UIStackView(arrangeHorizontally: registerAliasNote, registerAliasCheckbox)
            stackView.alignment = .center
            return stackView
        }()
        
        private let registerAliasNote = Label.Builder(label: .BodySmall())
            .set(text: Strings.registerBlikAliasNote)
            .set(color: .Colors.Neutral._500)
            .set(numberOfLines: 0)
            .set(isUserInteractionEnabled: true)
            .build()
        
        private let registerAliasCheckbox: Button.Checkbox = {
            let checkbox = Button.Checkbox()
            checkbox.setContentHuggingPriority(.required, for: .horizontal)
            return checkbox
        }()
        
        private lazy var aliasLabel: TextInput = {
            let textField = TextField()
            let input = TextInput(textField: textField)
            input.placeholder = Strings.aliasLabelPlaceholder
            input.isHidden = true
            return input
        }()
        
        private let bottomSection = BottomSection(with: .init(actionButtonTitle: .empty,
                                                              withSecondaryAction: false,
                                                              withGdprNote: true,
                                                              withRegulationsNote: true))
        private let bottomSectionPlaceholder = UIView()
        
        // MARK: - Initializers
        
        init(isNavigationToAliasesEnabled: Bool) {
            self.isNavigationToAliasesEnabled = isNavigationToAliasesEnabled
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            setupLayout()
        }
        
        // MARK: - API
        
        func set(transaction: Domain.Transaction) {
            bottomSection.set(amount: transaction.paymentInfo.amount)
        }
        
        func set(blikCodeState: InputContentState) {
            blikCode.set(inputContentState: blikCodeState)
        }
        
        func set(isProcessing: Bool) {
            bottomSection.set(isProcessing: isProcessing)
        }
        
        func set(isAliasRegistrationSectionHidden: Bool) {
            aliasRegistrationSection.isHidden = isAliasRegistrationSectionHidden
        }
        
        func set(isAliasLabelInputHidden: Bool) {
            aliasLabel.isHidden = isAliasLabelInputHidden
        }
        
        // MARK: - PinnableContentProvider
        
        func adjustAfterPinning() {
            fillPinnedContentSpace()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            translatesAutoresizingMaskIntoConstraints = false
            
            isNavigationToAliasesEnabled ? setupLayoutWithNavigation() : setupLayoutWithoutNavigation()
            
            aliasRegistrationSection.layout
                .add(to: self)
                .top.equalTo(blikCode, .bottom).with(constant: 16)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .activate()
            
            registerAliasCheckboxContainer.layout
                .leading.equalTo(aliasRegistrationSection, .leading).with(constant: 8)
                .trailing.equalTo(aliasRegistrationSection, .trailing).with(constant: -8)
                .activate()
            
            aliasLabel.layout
                .leading.equalTo(aliasRegistrationSection, .leading)
                .trailing.equalTo(aliasRegistrationSection, .trailing)
                .activate()
        }
        
        private func setupLayoutWithNavigation() {
            navigateToAliasesButton.layout
                .add(to: self)
                .top.equalTo(self, .top).with(constant: 16)
                .leading.equalTo(self, .leading).with(constant: 24)
                .activate()
            
            blikCode.layout
                .add(to: self)
                .top.equalTo(navigateToAliasesButton, .bottom).with(constant: 8)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .activate()
        }
        
        private func setupLayoutWithoutNavigation() {
            blikCode.layout
                .add(to: self)
                .top.equalTo(self, .top).with(constant: 16)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .activate()
        }
        
        private func fillPinnedContentSpace() {
            bottomSectionPlaceholder.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(aliasRegistrationSection, .bottom).with(constant: 16)
                .bottom.equalTo(self, .bottom)
                .height.greaterThanOrEqualTo(pinnableContent, .height)
                .activate()
        }
    }
}
