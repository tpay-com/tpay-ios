//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithCardViewController.ContentView {
    
    final class Partners: UIView {
        
        // MARK: - Properties
        
        private lazy var idCheckLogo: UIView = {
            let image = UIImageView(image: Asset.Icons.idCheckLogo.image)
            image.contentMode = .center
            return image
        }()
        
        private let verifiedByVisa: UIView = {
            let image = UIImageView(image: Asset.Icons.verifiedByVisa.image)
            image.contentMode = .center
            return image
        }()
        
        private let pciLogo: UIView = {
            let image = UIImageView(image: Asset.Icons.pciLogo.image)
            image.contentMode = .center
            return image
        }()
        
        private lazy var container: UIView = {
            let stackView = UIStackView(arrangeHorizontally: idCheckLogo, verifiedByVisa, pciLogo)
            stackView.spacing = 16
            return stackView
        }()
        
        // MARK: - Initializers
        
        init() {
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupLayout()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            container.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .top.equalTo(self, .top)
                .bottom.equalTo(self, .bottom)
                .activate()
        }
    }
}
