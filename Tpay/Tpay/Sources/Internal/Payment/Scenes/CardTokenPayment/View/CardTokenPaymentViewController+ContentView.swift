//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

extension CardTokenPaymentViewController {
    
    final class ContentView: UIView {
        
        // MARK: - Properties
        
        private lazy var container: UIView = {
            UIView()
        }()
        
        private lazy var timeIcon: UIView = {
            TimeIcon()
        }()
        
        private lazy var title: UILabel = {
            Label.Builder(label: Label.H1())
                .set(color: .Colors.Primary._900)
                .build()
        }()
        
        private lazy var message: UILabel = {
            Label.Builder(label: Label.BodySmall())
                .set(color: .Colors.Neutral._500)
                .set(numberOfLines: 0)
                .set(textAlignment: .center)
                .build()
        }()
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
        }
        
        // MARK: - API
        
        func set(title: String) {
            self.title.text = title
        }
        
        func set(message: String) {
            self.message.text = message
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            container.layout
                .add(to: self)
                .xAxis.center(with: self)
                .yAxis.center(with: self).with(constant: -30)
                .activate()
            
            timeIcon.layout
                .add(to: container)
                .xAxis.center(with: container)
                .top.equalTo(container, .top)
                .activate()
            
            title.layout
                .add(to: container)
                .xAxis.center(with: container)
                .width.lessThanOrEqualTo(self, .width).multiplied(by: 0.7)
                .top.equalTo(timeIcon, .bottom).with(constant: 32)
                .activate()
            
            message.layout
                .add(to: container)
                .xAxis.center(with: container)
                .width.lessThanOrEqualTo(self, .width).multiplied(by: 0.5)
                .top.equalTo(title, .bottom).with(constant: 16)
                .bottom.equalTo(container, .bottom)
                .activate()
        }
    }
}
