//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension DesignSystem.ViewController.ContentView {
    
    class TextInputs {
        
        lazy var view: UIView = {
            let stackView = UIStackView(arrangeVertically: enabledTextInput, cardNumberTextInput, dateTextInput, disabledTextInput, errorTextInput)
            stackView.spacing = 8
            return stackView
        }()
        
        // MARK: - Private

        private lazy var enabledTextInput: TextInput = {
            let textField = TextField.CVC(kind: .threeDigit)
            let textInput = TextInput(textField: textField)
            textInput.state = .enabled
            textInput.placeholder = "CVC"
            return textInput
        }()
        
        private lazy var dateTextInput: ExpiryDateInput = {
            let textInput = ExpiryDateInput()
            textInput.placeholder = "Data"
            textInput.state = .enabled
            return textInput
        }()
        
        private lazy var cardNumberTextInput: TextInput = {
            let textField = TextField.CardNumber()
            let textInput = TextInput(textField: textField)
            textInput.state = .enabled
            textInput.placeholder = "Numer karty"
            return textInput
        }()
        
        private lazy var disabledTextInput: TextInput = {
            let textInput = TextInput()
            textInput.state = .disabled
            textInput.placeholder = "Label"
            return textInput
        }()
        
        private lazy var errorTextInput: TextInput = {
            let textInput = TextInput()
            textInput.placeholder = "Text"
            textInput.error = "Błędzik"
            textInput.state = .error
            return textInput
        }()
    }
}
