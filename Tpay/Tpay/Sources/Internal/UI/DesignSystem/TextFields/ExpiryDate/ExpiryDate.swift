//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension TextField {
    
    class ExpiryDate: TextField {
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            setup()
        }
        
        // MARK: - Private
        
        private func setup() {
            keyboardType = .numberPad
            setupDelegation()
        }
        
        private func setupDelegation() {
            delegate = delegateMethods
            delegateMethods.shouldChangeCharactersIn { textField, range, string in
                guard let oldText = textField.text, let r = Range(range, in: oldText) else { return true }
                let updatedText = oldText.replacingCharacters(in: r, with: string)

                if string.isEmpty {
                    if updatedText.count == 2 {
                        textField.text = "\(updatedText.prefix(1))"
                        return false
                    }
                } else if updatedText.count == 1 {
                    if updatedText > "1" {
                        return false
                    }
                } else if updatedText.count == 2 {
                    if updatedText <= "12" && updatedText != "00" {
                        textField.text = "\(updatedText)/"
                    }
                    return false
                } else if updatedText.count > 5 {
                    return false
                }
                return true
            }
        }
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            false
        }
        
        override func closestPosition(to point: CGPoint) -> UITextPosition? {
            endOfDocument
        }
    }
}
