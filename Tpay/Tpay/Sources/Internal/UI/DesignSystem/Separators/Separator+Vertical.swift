//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Separator {
    
    final class Vertical: UIView {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: super.intrinsicContentSize.width, height: 1)
        }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupAppearance()
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral._200.color
        }
    }
}
