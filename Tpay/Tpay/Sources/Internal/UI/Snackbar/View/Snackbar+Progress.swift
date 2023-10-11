//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Snackbar {
    
    final class Progress: UIProgressView {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: super.intrinsicContentSize.width, height: 4)
        }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupAppearance()
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            trackTintColor = .black.withAlphaComponent(0.15)
            tintColor = .white.withAlphaComponent(0.6)
        }
    }
}
