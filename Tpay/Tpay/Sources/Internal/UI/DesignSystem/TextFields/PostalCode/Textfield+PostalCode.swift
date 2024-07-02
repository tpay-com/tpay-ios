//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

extension TextField {
    
    class PostalCode: TextField, UITextFieldDelegate {
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setup()
        }
        
        // MARK: - Overrides
        
        override func closestPosition(to point: CGPoint) -> UITextPosition? {
            endOfDocument
        }
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            false
        }
        
        // MARK: - Private
        
        private func setup() {
            setupAppearance()
            setupDelegation()
        }
        
        private func setupAppearance() {
            keyboardType = .numbersAndPunctuation
            textContentType = .postalCode
        }
        
        private func setupDelegation() {
            delegateMethods.shouldChangeCharactersIn { textField, range, string in
                guard let currentText = textField.text else { return false }
                let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
                
                if newText.count > 6 {
                    return false
                }
                
                return true
            }
        }
    }
}
