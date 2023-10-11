//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension FailureViewController {
    
    final class ContentView: UIView {
        
        // MARK: - Events
        
        private(set) lazy var primaryButtonTapped: Observable<Void> = primaryButton.tap
        private(set) lazy var cancelButtonTapped: Observable<Void> = cancelButton.tap
        
        // MARK: - Properties
        
        private lazy var container: UIView = {
            UIView()
        }()
        
        private lazy var failureIcon: UIView = {
            FailureIcon()
        }()
        
        private lazy var title: UILabel = {
            Label.Builder(label: Label.H1())
                .set(color: .Colors.Primary._900)
                .set(numberOfLines: 0)
                .set(textAlignment: .center)
                .build()
        }()
        
        private lazy var failureDescription: UILabel = {
            Label.Builder(label: Label.BodySmall())
                .set(color: .Colors.Neutral._500)
                .set(numberOfLines: 0)
                .set(textAlignment: .center)
                .build()
        }()
        
        private lazy var buttonsContainer: UIView = {
            let stackView = UIStackView(arrangeVertically: primaryButton, cancelButton)
            stackView.spacing = 16
            return stackView
        }()
        
        private lazy var primaryButton: UIButton = {
            Button.Primary.Builder(button: Button.Primary())
                .build()
        }()
        
        private lazy var cancelButton: UIButton = {
            Button.Link.Builder(button: Button.Link())
                .build()
        }()
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupLayout()
        }
        
        // MARK: - API
        
        func set(content: FailureContent) {
            self.title.attributedText = NSAttributedString(string: content.title)
            failureDescription.attributedText = NSAttributedString(string: content.description ?? .empty)
            primaryButton.setTitle(content.primaryButtonTitle, for: .normal)
            cancelButton.isHidden = content.linkButtonTitle == nil
            cancelButton.setTitle(content.linkButtonTitle, for: .normal)
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            container.layout
                .add(to: self)
                .xAxis.center(with: self)
                .yAxis.center(with: self).with(constant: -30)
                .activate()
            
            failureIcon.layout
                .add(to: container)
                .xAxis.center(with: container)
                .top.equalTo(container, .top)
                .activate()
            
            title.layout
                .add(to: container)
                .xAxis.center(with: container)
                .width.lessThanOrEqualTo(self, .width).multiplied(by: 0.5)
                .top.equalTo(failureIcon, .bottom).with(constant: 32)
                .activate()
            
            failureDescription.layout
                .add(to: container)
                .xAxis.center(with: container)
                .width.lessThanOrEqualTo(self, .width).multiplied(by: 0.75)
                .top.equalTo(title, .bottom).with(constant: 16)
                .bottom.equalTo(container, .bottom)
                .activate()
            
            buttonsContainer.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .bottom.equalTo(self, .bottom).with(constant: -16)
                .top.greaterThanOrEqualTo(container, .bottom).with(priority: .defaultHigh).with(constant: 32)
                .activate()
        }
    }
}
