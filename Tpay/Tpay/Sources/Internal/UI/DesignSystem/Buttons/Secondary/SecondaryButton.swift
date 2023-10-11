//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Button {
    
    class Secondary: UIButton {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: super.intrinsicContentSize.width, height: 32)
        }
        
        override var isHighlighted: Bool {
            didSet {
                guard oldValue != isHighlighted else { return }
                updateAppearance()
            }
        }
        
        private let icon: UIImage
        private let accessoryAlignment: AccessoryAlignment
        
        // MARK: - Initializers
        
        init(icon: UIImage, alignment: Button.Secondary.AccessoryAlignment) {
            self.icon = icon
            accessoryAlignment = alignment
            super.init(frame: .zero)
            
            setupAppearance()
            prepareForReuse()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func layoutSubviews() {
            super.layoutSubviews()
            setupInsets()
        }
        
        // MARK: - API
        
        func prepareForReuse() {
            backgroundColor = .Colors.Primary._100.color
            setTitleColor(.Colors.Primary._500.color, for: .normal)
            setImage(icon, for: .normal)
        }
        
        func setupInsets() {
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
            imageEdgeInsets.left = accessoryAlignment == .leading ? -4 : 4
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            backgroundColor = .Colors.Primary._100.color
            tintColor = .Colors.Primary._500.color
            layer.cornerRadius = 13
            layer.masksToBounds = true
            
            setTitleColor(.Colors.Primary._500.color, for: .normal)
            titleLabel?.font = DesignSystem.Font.medium.font(size: 13)
            
            semanticContentAttribute = accessoryAlignment == .leading ? .forceLeftToRight : .forceRightToLeft
            setImage(icon, for: .normal)
        }
        
        private func updateAppearance() {
            isHighlighted ? setHighlight() : unsetHighlight()
        }
        
        private func setHighlight() {
            backgroundColor = .Colors.Primary._200.color
        }
        
        private func unsetHighlight() {
            backgroundColor = .Colors.Primary._100.color
        }
    }
}
