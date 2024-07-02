//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

extension TextField {
    
    class Country: TextField, UIPickerViewDelegate, UIPickerViewDataSource {
        
        // MARK: - Properties
        
        private let picker = UIPickerView()
        private let options: [String]
        
        // MARK: - Lifecycle
        
        init(with options: [String]) {
            self.options = options
            super.init(frame: .zero)
        }
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setup()
        }
        
        // MARK: - Overrides
        
        override func caretRect(for position: UITextPosition) -> CGRect {
            .zero
        }
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            false
        }
        
        // MARK: - Private
        
        private func setup() {
            setupAppearance()
            setupPicker()
            
            text = options.first
        }
        
        private func setupAppearance() {
            inputView = picker
            textContentType = .countryName
        }
        
        private func setupPicker() {
            picker.delegate = self
            picker.dataSource = self
        }
        
        // MARK: - UIPickerViewDataSource
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            options.count
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            options.count
        }
        
        // MARK: - UIPickerViewDelegate
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            options[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            text = options[row]
        }
    }
}
