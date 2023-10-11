//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension TextField {
    
    class CVC: TextField {
        
        // MARK: - Properties
        
        var kind: Kind
        
        // MARK: - Initializers
        
        init(kind: Kind = .threeDigit) {
            self.kind = kind
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
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
                let textField = textField as? TextField.CVC
                let currentText = textField?.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                return updatedText.count <= textField?.kind.numberOfCharacters ?? 4
            }
        }
    }
}
