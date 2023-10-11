//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class TextInput: UIView {
    
    // MARK: - Events

    private(set) lazy var onValueReset = textField.onValueReset
    private(set) lazy var valueEmitted = Observable.combineLatest(textField.editingChanged, textField.editingDidEnd.skip(until: { $0.isNotEmpty })).map { $0.0 }
    
    // MARK: - Properties
    
    var state: TextField.State = .enabled {
        didSet {
            setupState()
        }
    }
    
    var text: String? {
        didSet {
            textField.text = text
            text.value(or: .empty).isEmpty ? removeFloatingLabel() : addFloatingLabel()
        }
    }
    
    var placeholder: String? {
        didSet {
            adjustPlaceholderSize()
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
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    private var placeholderLabel: Label = {
        let label = Label.Small()
        label.font = DesignSystem.Font.regular.font(size: 15)
        label.textColor = .Colors.Neutral._500.color
        return label
    }()
    
    private var errorLabel: Label = {
        let label = Label.Micro()
        label.textColor = .Colors.Semantic.error.color
        return label
    }()
    
    private let errorView = UIView()
    
    private let textField: TextField
    
    private lazy var topConstraint = placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                                                           constant: Constants.defaultTextInsets.top + Constants.defaultTopMargin)
    
    // MARK: - Initializers
    
    init(textField: TextField = TextField()) {
        self.textField = textField
        super.init(frame: .zero)
        delegateMethods()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }
    
    // MARK: - Overrides
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }
    
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
        setupLayout()
        setupState()
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
        translatesAutoresizingMaskIntoConstraints = false
        
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
            self?.state = .active
            self?.addFloatingLabel()
        }
        
        textField.delegateMethods.endEditing { [weak self] _ in
            if (self?.textField.text ?? .empty).isEmpty {
                self?.state = .enabled
                self?.removeFloatingLabel()
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
                          animations: {
            self.adjustPlaceholderSize()
            self.placeholderLabel.backgroundColor = .white
        })

        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    private func removeFloatingLabel() {
        self.topConstraint.constant = Constants.defaultTextInsets.top + Constants.defaultTopMargin
        UIView.transition(with: placeholderLabel,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: {
            self.placeholderLabel.backgroundColor = .clear
            self.adjustPlaceholderSize()
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    private func adjustPlaceholderSize() {
        guard let placeholder = placeholder else { return }
        let isTextFieldEmpty = textField.text?.isEmpty ?? true
        var fontSize: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        switch (state, isTextFieldEmpty) {
        case (.active, _):
            fontSize = 11
            lineHeight = 13
        case (.enabled, true), (.disabled, true), (.filled, true):
            fontSize = 15
            lineHeight = 20
        case (.enabled, false), (.disabled, false), (.filled, false):
            fontSize = 11
            lineHeight = 13
        case (.error, false):
            fontSize = 11
            lineHeight = 13
        case (.error, true):
            fontSize = 15
            lineHeight = 20
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        let font: UIFont = DesignSystem.Font.regular.font(size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .font: font]
        let attributedString = NSAttributedString(string: placeholder,
                                                  attributes: attributes)
        placeholderLabel.attributedText = attributedString
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
