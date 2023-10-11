//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Label {
    
    final class Builder {
        
        // MARK: - Properties
        
        private let label: Label
        
        // MARK: - Initializers
        
        init(label: Label) {
            self.label = label
        }
        
        // MARK: - API
        
        func build() -> Label {
            label
        }
        
        func set(text: String?) -> Self {
            label.text = text
            return self
        }
        
        func setText(asHtml: String) -> Self {
            label.setText(asHtml: asHtml)
            return self
        }
        
        func set(color: DesignSystem.Color) -> Self {
            label.set(color: color)
            return self
        }
        
        func set(numberOfLines: Int) -> Self {
            label.numberOfLines = numberOfLines
            return self
        }
        
        func set(isUserInteractionEnabled: Bool) -> Self {
            label.isUserInteractionEnabled = isUserInteractionEnabled
            return self
        }
        
        func set(textAlignment: NSTextAlignment) -> Self {
            label.textAlignment = textAlignment
            return self
        }
        
    }
}
