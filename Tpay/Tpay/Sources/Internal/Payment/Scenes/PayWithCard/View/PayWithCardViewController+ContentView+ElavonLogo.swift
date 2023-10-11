//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension PayWithCardViewController.ContentView {
    
    final class ElavonLogo: UIView {
        
        // MARK: - Properties
        
        private let poweredByLabel = Label.Builder(label: .Micro())
            .set(text: Strings.poweredBy)
            .set(color: .Colors.Neutral._500)
            .build()
        
        private let logo = UIImageView(image: Asset.Icons.elavonLogo.image)
        
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
            poweredByLabel.layout
                .add(to: self)
                .leading.equalTo(self, .leading)
                .top.equalTo(self, .top)
                .bottom.equalTo(self, .bottom)
                .activate()

            logo.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing)
                .leading.equalTo(poweredByLabel, .trailing).with(constant: 5)
                .bottom.equalTo(poweredByLabel, .bottom).with(constant: -2)
                .activate()
        }
    }
}
