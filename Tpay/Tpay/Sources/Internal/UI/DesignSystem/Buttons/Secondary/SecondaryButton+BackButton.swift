//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Button.Secondary {
    
    final class BackButton: Button.Secondary {
        
        // MARK: - Initializers
        
        convenience init(text: String) {
            self.init(icon: DesignSystem.Icons.rightArrow.image, alignment: Button.Secondary.AccessoryAlignment.leading)
            self.setTitle(text, for: .normal)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            setupImageView()
        }
        
        // MARK: - Overrides
        
         override func setupInsets() {
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
            imageEdgeInsets.left = -8
        }
        
        // MARK: - Private
        
        private func setupImageView() {
            if let imageView = self.imageView {
                imageView.bounds = CGRect(x: 18.75, y: 11, width: 11, height: 11)
                imageView.contentMode = .scaleAspectFit
                imageView.transform = transform.rotated(by: .pi)
            }
        }
    }
}
