//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension TextField {

    class Delegate: NSObject {
        
        // MARK: - Properties
        
        private var _beginEditing: (() -> Void)?
        private var _endEditing: ((String?) -> Void)?
        private var _shouldChangeCharactersIn: ((UITextField, NSRange, String) -> Bool)?
        
        // MARK: - API
        
        func beginEditing(handler: (() -> Void)?) {
            _beginEditing = handler
        }
        
        func endEditing(_ handler: ((String?) -> Void)?) {
            _endEditing = handler
        }
        
        func shouldChangeCharactersIn(_ handler: ((UITextField, NSRange, String) -> Bool)?) {
            _shouldChangeCharactersIn = handler
        }
    }
}

extension TextField.Delegate: UITextFieldDelegate {
     
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _beginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _endEditing?(textField.text)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _shouldChangeCharactersIn?(textField, range, string) ?? true
    }
}
