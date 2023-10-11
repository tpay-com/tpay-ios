//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension TextField {
    
    class CardNumber: TextField {
        
        // MARK: - Events
        
        let ocrButtonTapped = Observable<Void>()
        
        // MARK: - Properties
        
        override var textFieldState: State {
            didSet {
                setupState()
            }
        }
        
        private lazy var rightStackView: UIStackView = {
            let stackView = UIStackView(arrangeHorizontally: cardBrandView, ocrButton)
            stackView.alignment = .center
            stackView.spacing = 16
            return stackView
        }()
        
        private let cardBrandView = CardBrandView(brandImage: .init(), appearance: .small)
        private let ocrButton = UIButton()
        
        private var previousTextFieldContent: String?
        private var previousSelection: UITextRange?
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            setup()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            setupOcrButton()
        }
        
        // MARK: - Text Insets
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: UIEdgeInsets(top: Constants.defaultTextInsets.top,
                                          left: Constants.defaultTextInsets.left,
                                          bottom: Constants.defaultTextInsets.bottom,
                                          right: Constants.defaultTextInsets.right + rightStackView.frame.width))
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: UIEdgeInsets(top: Constants.defaultTextInsets.top,
                                          left: Constants.defaultTextInsets.left,
                                          bottom: Constants.defaultTextInsets.bottom,
                                          right: Constants.defaultTextInsets.right + rightStackView.frame.width))
        }
        
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            bounds.inset(by: UIEdgeInsets(top: Constants.defaultTextInsets.top,
                                          left: Constants.defaultTextInsets.left,
                                          bottom: Constants.defaultTextInsets.bottom,
                                          right: Constants.defaultTextInsets.right + rightStackView.frame.width))
        }
        
        // MARK: - Overrides
        
        override func setupState() {
            super.setupState()
            
            switch textFieldState {
            case .disabled:
                ocrButton.tintColor = DesignSystem.Colors.Neutral._300.color
                ocrButton.backgroundColor = .white
            default:
                ocrButton.tintColor = DesignSystem.Colors.Primary._500.color
                ocrButton.backgroundColor = DesignSystem.Colors.Primary._100.color
            }
        }
        
        // MARK: - API
        
        func set(cardBrand: Domain.CardToken.Brand?) {
            defer {
                if case .other = cardBrand { cardBrandView.hide() } else { cardBrand != nil ? cardBrandView.show() : cardBrandView.hide() }
            }
            guard let cardBrand = cardBrand else { return }
            cardBrandView.set(brand: cardBrand)
        }
        
        // MARK: - Private
        
        private func setup() {
            setupAppearance()
            setupActions()
            setupLayout()
            setupOcrButton()
            setupDelegation()
        }
        
        private func setupAppearance() {
            keyboardType = .numberPad
            set(cardBrand: nil)
        }
        
        private func setupActions() {
            addTarget(self, action: #selector(creditCardString), for: .editingChanged)
            ocrButton.addTarget(self, action: #selector(pressed), for: [.touchDown])
            ocrButton.addTarget(self, action: #selector(released), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])
        }
        
        private func setupDelegation() {
            delegateMethods.shouldChangeCharactersIn { [weak self] textField, range, string in
                // TODO: - Add formatting for different credit cards
                let currentText: String = textField.text ?? .empty
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                self?.previousTextFieldContent = textField.text
                self?.previousSelection = textField.selectedTextRange
                return updatedText.count <= 23
            }
        }
        
        private func setupOcrButton() {
            ocrButton.setImage(DesignSystem.Icons.ocr.image, for: .normal)
            ocrButton.addTarget(self, action: #selector(startOcr), for: .touchUpInside)
            ocrButton.layer.cornerRadius = ocrButton.bounds.height / 2
            ocrButton.layer.masksToBounds = true
            if #available(iOS 13.0, *) {
                ocrButton.isHidden = !UIImagePickerController.isCameraDeviceAvailable(.rear)
            } else {
                ocrButton.isHidden = true
            }
        }
        
        private func setupLayout() {
            rightStackView.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing).with(constant: -Constants.defaultTextInsets.right)
                .yAxis.center(with: self)
                .activate()
            
            ocrButton.layout
                .height.equalTo(constant: 32)
                .width.equalTo(ocrButton, .height)
                .activate()
        }
        
        @objc private func startOcr() {
            ocrButtonTapped.on(.next(()))
        }
        
        @objc private func pressed() {
            ocrButton.backgroundColor = DesignSystem.Colors.Primary._200.color
        }
        
        @objc private func released() {
            ocrButton.backgroundColor = DesignSystem.Colors.Primary._100.color
        }
        
        @objc private func creditCardString() {
            var targetCursorPosition = 0
            if let startPosition = selectedTextRange?.start {
                targetCursorPosition = offset(from: beginningOfDocument, to: startPosition)
            }
            
            var cardNumberWithoutSpaces: String = .empty
            if let text = text {
                cardNumberWithoutSpaces = removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
            }
            
            let cardNumberWithSpaces = insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            text = cardNumberWithSpaces
            
            if let targetPosition = position(from: beginningOfDocument, offset: targetCursorPosition) {
                selectedTextRange = textRange(from: targetPosition, to: targetPosition)
            }
        }
        
        private func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
            var digitsOnlyString: String = .empty
            let originalCursorPosition = cursorPosition
            
            for i in Swift.stride(from: 0, to: string.count, by: 1) {
                let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
                if characterToAdd >= "0" && characterToAdd <= "9" {
                    digitsOnlyString.append(characterToAdd)
                } else if i < originalCursorPosition {
                    cursorPosition -= 1
                }
            }
            
            return digitsOnlyString
        }
        
        private func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
            let cursorPositionInSpacelessString = cursorPosition
            var cardNumberString: String = .empty
            for i in 0..<string.count {
                if i > 0 && (i % 4) == 0 {
                    cardNumberString.append(.separator)
                    if i < cursorPositionInSpacelessString {
                        cursorPosition += 1
                    }
                }
                
                let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
                cardNumberString.append(characterToAdd)
            }
            return cardNumberString
        }
    }
}

fileprivate extension String {
    
    static let separator = " "
}
