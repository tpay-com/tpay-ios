//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SheetViewController {
    
    final class CardView: UIView {
        
        // MARK: - Events
        
        var closeButtonTapped: Observable<Void> { closeButton.tap }
        
        // MARK: - Properties
        
        private let title = Label.H1()
        private let imageView = UIImageView()
        private let contentView = UIView()
        private let topShadowEmmiter = TopShadowEmitter()
        
        private lazy var titleContainer: UIView = {
            let arrangedSubviews: [UIView] = [title, imageView, UIView()]
            let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
            stackView.axis = .horizontal
            stackView.spacing = 16
            return stackView
        }()
        
        private lazy var closeButton: UIButton = {
            let closeIcon = DesignSystem.Icons.close.image
                .scalePreservingAspectRatio(targetSize: .init(width: 12.75, height: 12.75))
                .withRenderingMode(.alwaysTemplate)
            let button = Button.Icon(icon: closeIcon)
            button.imageView?.tintColor = .Colors.Neutral._500.color
            button.setContentHuggingPriority(.required, for: .horizontal)
            return button
        }()
        
        // MARK: - Lifecycle
        
        init() {
            super.init(frame: .zero)
            
            setupLayout()
            setupAppearance()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - API
        
        func set(title: String?) {
            self.title.text = title
        }
        
        func set(titleImage: UIImage?) {
            imageView.image = titleImage
        }
        
        func set(content: UIView) {
            content.layout
                .add(to: contentView)
                .leading.equalTo(contentView, .leading)
                .trailing.equalTo(contentView, .trailing)
                .top.equalTo(contentView, .top)
                .bottom.equalTo(contentView, .bottom)
                .activate()
        }
        
        func set(isCancellable: Bool) {
            isCancellable ? closeButton.show() : closeButton.hide()
        }
        
        func shade() {
            topShadowEmmiter.shade()
        }
        
        func removeShade() {
            topShadowEmmiter.removeShade()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            closeButton.layout
                .add(to: self)
                .top.equalTo(self, .top).with(constant: 18)
                .trailing.equalTo(self, .trailing).with(constant: -16)
                .activate()
            
            titleContainer.layout
                .add(to: self)
                .top.equalTo(self, .top).with(constant: 24)
                .leading.equalTo(self, .leading).with(constant: 24)
                .trailing.equalTo(closeButton, .leading).with(constant: -24)
                .activate()
            
            topShadowEmmiter.layout
                .add(to: self)
                .top.equalTo(self, .top)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .height.equalTo(constant: 60)
                .activate()
            
            contentView.layout
                .add(to: self)
                .top.equalTo(topShadowEmmiter, .bottom)
                .leading.equalTo(self, .leading)
                .trailing.equalTo(self, .trailing)
                .bottom.equalTo(safeAreaLayoutGuide, .bottom)
                .activate()
            
            bringSubviewToFront(topShadowEmmiter)
            bringSubviewToFront(titleContainer)
            bringSubviewToFront(closeButton)
        }
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral.white.color
            
            layer.cornerRadius = 24
            layer.masksToBounds = true
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
}
