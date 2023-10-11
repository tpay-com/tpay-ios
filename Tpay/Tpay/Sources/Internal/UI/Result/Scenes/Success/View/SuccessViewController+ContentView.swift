//
//  Copyright © 2022 Tpay. All rights reserved.
//

import SwiftUI
import UIKit

extension SuccessViewController {
    
    final class ContentView: UIView {
        
        // MARK: - Events
        
        private(set) lazy var buttonTapped: Observable<Void> = button.tap
        
        // MARK: - Properties
        
        private lazy var container: UIView = {
            UIView()
        }()
        
        private lazy var successIcon: UIView = {
            SuccessIcon()
        }()
        
        private lazy var title: UILabel = {
            Label.Builder(label: Label.H1())
                .set(color: .Colors.Primary._900)
                .set(numberOfLines: 0)
                .set(textAlignment: .center)
                .build()
        }()
        
        private lazy var successDescription: UILabel = {
            Label.Builder(label: Label.BodySmall())
                .set(color: .Colors.Neutral._500)
                .set(numberOfLines: 0)
                .set(textAlignment: .center)
                .build()
        }()
        
        private lazy var button: UIButton = {
            Button.Primary.Builder(button: Button.Primary())
                .build()
        }()
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
        }
        
        // MARK: - API
        
        func set(content: SuccessContent) {
            self.title.attributedText = NSAttributedString(string: content.title)
            successDescription.attributedText = NSAttributedString(string: content.description ?? .empty)
            button.setTitle(content.buttonTitle, for: .normal)
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            container.layout
                .add(to: self)
                .xAxis.center(with: self)
                .yAxis.center(with: self).with(priority: .defaultLow).with(constant: -30)
                .activate()
            
            successIcon.layout
                .add(to: container)
                .xAxis.center(with: container)
                .top.equalTo(container, .top)
                .activate()
            
            title.layout
                .add(to: container)
                .xAxis.center(with: container)
                .width.lessThanOrEqualTo(self, .width).multiplied(by: 0.5)
                .top.equalTo(successIcon, .bottom).with(constant: 32)
                .activate()
            
            successDescription.layout
                .add(to: container)
                .xAxis.center(with: container)
                .width.lessThanOrEqualTo(self, .width).multiplied(by: 0.75)
                .top.equalTo(title, .bottom).with(constant: 16)
                .bottom.equalTo(container, .bottom)
                .activate()
            
            button.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .bottom.equalTo(self, .bottom).with(constant: -16)
                .top.greaterThanOrEqualTo(container, .bottom).with(priority: .defaultHigh).with(constant: 32)
                .activate()
        }
    }
}
