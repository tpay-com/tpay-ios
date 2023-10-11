//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController {
    
    final class PayerDetailsView: UIView {
        
        // MARK: - Events
        
        private(set) lazy var changePayerDetails = Observable<Void>()
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: super.intrinsicContentSize.width, height: 69)
        }
        
        private lazy var name: Label = {
            Label.Builder(label: Label.Body())
                .set(color: .Colors.Primary._900)
                .build()
        }()
        
        private lazy var email: Label = {
            Label.Builder(label: Label.BodySmall())
                .set(color: .Colors.Neutral._500)
                .build()
        }()
        
        private lazy var rightArrow: UIImageView = {
            let imageView = UIImageView(image: Asset.Icons.rightArrow.image)
            imageView.tintColor = .Colors.Neutral._500.color
            return imageView
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
            setupAppearance()
            
            observeEvents()
        }
        
        // MARK: - API
        
        func set(name: String) {
            self.name.text = name
        }
        
        func set(email: String) {
            self.email.text = email
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            rightArrow.layout
                .add(to: self)
                .trailing.equalTo(self, .trailing).with(constant: -24)
                .yAxis.center(with: self)
                .height.equalTo(constant: 17)
                .width.equalTo(constant: 10)
                .activate()
            
            name.layout
                .add(to: self)
                .leading.equalTo(self, .leading).with(constant: 16)
                .trailing.equalTo(rightArrow, .trailing).with(constant: -16)
                .top.equalTo(self, .top).with(constant: 16)
                .activate()
            
            email.layout
                .add(to: self)
                .leading.equalTo(name, .leading)
                .trailing.equalTo(name, .trailing)
                .bottom.equalTo(self, .bottom).with(constant: -16)
                .activate()
        }
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral._100.color
            
            layer.cornerRadius = 13
            layer.masksToBounds = true
        }
        
        private func setHighlight() {
            backgroundColor = .Colors.Neutral._200.color
        }

        private func unsetHighlight() {
            backgroundColor = .Colors.Neutral._100.color
        }
        
        private func observeEvents() {
            tap.subscribe(onNext: { [weak self] _ in
                self?.unsetHighlight()
                self?.changePayerDetails.on(.next(()))
            })
            .add(to: disposer)
        }
        
        // MARK: - Overriden
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            setHighlight()
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            unsetHighlight()
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            unsetHighlight()
        }
    }
}
