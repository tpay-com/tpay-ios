//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension TextField {
    
    class Blik: TextField {
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setup()
        }
        
        // MARK: - Private
        
        private func setup() {
            setupAppearance()
            setupDelegation()
        }
        
        private func setupAppearance() {
            keyboardType = .numberPad
        }
        
        private func setupDelegation() {
            delegate = delegateMethods
            delegateMethods.shouldChangeCharactersIn { textField, range, string in
                let textField = textField as? TextField.Blik
                let currentText = textField?.text ?? .empty
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                return updatedText.count <= 6
            }
        }
    }
}
