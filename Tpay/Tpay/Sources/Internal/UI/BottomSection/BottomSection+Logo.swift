//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension BottomSection {
 
    final class Logo: UIView {
        
        // MARK: - Properties
        
        private lazy var separator: UIView = {
            Separator.Vertical()
        }()
                
        private lazy var tpayLogo: UIView = {
            UIImageView(image: Asset.Icons.tpayLogoLight.image)
        }()
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupLayout()
        }
        
        // MARK: - API
        
        func fadeIn() {
            show()
            UIView.animate(withDuration: 0.3) { [ weak self] in self?.alpha = 1 }
        }
        
        func fadeOut() {
            hide()
            alpha = 0
        }
                
        // MARK: - Private
        
        private func setupLayout() {
            separator.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(self, .top)
                .activate()
            
            tpayLogo.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .top.equalTo(separator, .bottom).with(constant: 16)
                .bottom.equalTo(self, .bottom)
                .activate()
        }
    }
}
