//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension UIButton {
    
    final class Builder {
        
        // MARK: - Properties
        
        private let button: UIButton
        
        // MARK: - Initializers
        
        init(button: UIButton) {
            self.button = button
        }
        
        // MARK: - API
        
        func build() -> UIButton {
            button
        }
        
        func set(title: String?) -> Self {
            button.setTitle(title, for: .normal)
            return self
        }
    }
}
