//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ExpiryDateInput: UIView {
    
    // MARK: - Events

    private(set) lazy var onValueReset = textField.onValueReset
    private(set) lazy var valueEmitted = Observable.combineLatest(textField.editingChanged,
                                                                  textField.editingDidEnd.skip(until: { $0.isNotEmpty })).map { $0.0 }
    
    // MARK: - Properties
    
    var state: TextField.State = .enabled {
        didSet {
            setupState()
        }
    }
    
    var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            adjustPlaceholderColor()
        }
    }
    
    var error: String? {
        didSet {
            errorLabel.text = error
        }
    }
    
    private lazy var textInputContainer: UIView = {
        let stackView = UIStackView(arrangeVertically: textField, errorView)
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private var placeholderLabel: Label = {
        let label = Label.Small(medium: DesignSystem.Colors.Neutral._500)
        label.alpha = 0.0
        label.text = Strings.cardExpiryDate
        return label
    }()
    
    private var errorLabel: Label = {
        let label = Label.Micro()
        label.textColor = DesignSystem.Colors.Semantic.error.color
        return label
    }()
    
    private var textField: TextField.ExpiryDate = {
        let textField = TextField.ExpiryDate()
        textField.placeholder = Strings.cardExpiryDate
        return textField
    }()
    
    private let errorView = UIView()
    
    private lazy var topConstraint = placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                                           constant: Constants.defaultTopMargin)
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setup()
        delegateMethods()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - API
    
    func set(inputContentState: InputContentState) {
        switch inputContentState {
        case .invalid(let inputValidationError):
            state = .error
            errorLabel.text = inputValidationError.description
        default:
            state = .enabled
            errorLabel.text = nil
        }
    }
    
    // MARK: - Private
    
    private func setup() {
        setupState()
        setupLayout()
    }
    
    private func setupState() {
        textField.textFieldState = state
        adjustPlaceholderColor()

        switch state {
        case .error:
            isUserInteractionEnabled = true
            errorView.isHidden = false
        case .disabled:
            isUserInteractionEnabled = false
        default:
            isUserInteractionEnabled = true
            errorView.isHidden = true
        }
    }
    
    private func setupLayout() {
        textInputContainer.layout
            .add(to: self)
            .top.equalTo(self, .top).with(constant: Constants.defaultTopMargin)
            .leading.equalTo(self, .leading)
            .trailing.equalTo(self, .trailing)
            .bottom.equalTo(self, .bottom)
            .activate()
        
        placeholderLabel.layout
            .add(to: self)
            .leading.equalTo(textInputContainer, .leading).with(constant: Constants.defaultTextInsets.left)
            .activate()
        
        errorLabel.layout
            .add(to: errorView)
            .top.equalTo(errorView, .top)
            .trailing.equalTo(errorView, .trailing).with(constant: -Constants.defaultTextInsets.right)
            .leading.equalTo(errorView, .leading).with(constant: Constants.defaultTextInsets.left)
            .bottom.equalTo(errorView, .bottom)
            .activate()
        
        NSLayoutConstraint.activate([topConstraint])
    }
    
    private func delegateMethods() {
        textField.delegateMethods.beginEditing { [weak self] in
            self?.placeholderLabel.textColor = DesignSystem.Colors.Primary._500.color
            self?.textField.placeholder = Strings.cardExpiryDateHint
            self?.addFloatingLabel()
            self?.state = .active
        }
        
        textField.delegateMethods.endEditing { [weak self] _ in
            self?.placeholderLabel.textColor = DesignSystem.Colors.Neutral._500.color
            self?.textField.placeholder = Strings.cardExpiryDate
            
            if (self?.textField.text ?? .empty).isEmpty {
                self?.removeFloatingLabel()
                self?.state = .enabled
            } else {
                self?.state = .filled
                self?.adjustPlaceholderColor()
            }
        }
    }
    
    private func addFloatingLabel() {
        self.topConstraint.constant = 0
        UIView.transition(with: placeholderLabel,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.placeholderLabel.backgroundColor = .white })
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.placeholderLabel.alpha = 1.0
            self?.layoutIfNeeded()
        }
    }
    
    private func removeFloatingLabel() {
        self.topConstraint.constant = Constants.defaultTopMargin
        UIView.transition(with: placeholderLabel,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.placeholderLabel.backgroundColor = .clear })
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.placeholderLabel.alpha = 0.0
            self?.layoutIfNeeded()
        }
    }
    
    private func adjustPlaceholderColor() {
        
        switch state {
        case .active:
            placeholderLabel.textColor = .Colors.Primary._500.color
        case .error:
            placeholderLabel.textColor = .Colors.Semantic.error.color
        default:
            placeholderLabel.textColor = .Colors.Neutral._500.color
        }
    }
}
