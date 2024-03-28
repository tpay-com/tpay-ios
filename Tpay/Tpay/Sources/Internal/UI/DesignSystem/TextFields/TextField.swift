//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    // MARK: - Events
    
    private(set) lazy var onValueReset = Observable<Void>()
    private(set) lazy var editingChanged = Observable<String>()
    private(set) lazy var editingDidEnd = Observable<String>()
    
    // MARK: - Properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: Constants.defaultHeight)
    }
    
    override var placeholder: String? {
        didSet {
            setupAppearance()
        }
    }
    
    var textFieldState: State = .enabled {
        didSet {
            setupState()
        }
    }
    
    let delegateMethods = Delegate()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }
    
    // MARK: - Text insets
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.defaultTextInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.defaultTextInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.defaultTextInsets)
    }
    
    // MARK: - API
    
    func setupState() {
        layer.borderColor = textFieldState.borderColor.cgColor
        backgroundColor = textFieldState.backgroundColor
        attributedPlaceholder = NSAttributedString(string: placeholder ?? .empty,
                                                   attributes: [.foregroundColor: textFieldState.foregroundColor])
        
        switch textFieldState {
        case .disabled:
            isUserInteractionEnabled = false
        default: break
        }
    }
    
    func reset() {
        text = nil
        onValueReset.on(.next(()))
    }
    
    // MARK: - Private
    
    private func setup() {
        setupAppearance()
        setupState()
        setupActions()
        
        delegate = delegateMethods
    }

    private func setupAppearance() {
        font = DesignSystem.Font.regular.font(size: Constants.defaultFontSize)
        textColor = DesignSystem.Colors.Primary._900.color
        attributedPlaceholder = NSAttributedString(string: placeholder ?? .empty,
                                                   attributes: [.foregroundColor: DesignSystem.Colors.Neutral._500.color])
        
        borderStyle = .none
        layer.cornerRadius = Constants.defaultRadius
        layer.borderWidth = Constants.defaultBorderWidth
    }
    
    private func setupActions() {
        addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
    }
    
    @objc private func handleEditingChanged() {
        editingChanged.on(.next(text.value(or: .empty)))
    }
    
    @objc private func handleEditingDidEnd() {
        editingDidEnd.on(.next(text.value(or: .empty)))
    }
}
