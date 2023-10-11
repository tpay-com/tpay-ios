//
//  Copyright © 2022 Tpay. All rights reserved.
//
import UIKit

extension Button {
    
    final class Icon: UIButton {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: 32, height: 32)
        }
        
        override var isHighlighted: Bool {
            didSet {
                guard oldValue != isHighlighted else { return }
                updateAppearance()
            }
        }
        
        private let image: UIImage
        
        // MARK: - Initializers
        
        init(icon: UIImage) {
            self.image = icon
            super.init(frame: .zero)
            
            setupAppearance()
            prepareForReuse()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - API
        
        func prepareForReuse() {
            backgroundColor = .Colors.Neutral._100.color
            setImage(image, for: .normal)
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            backgroundColor = .Colors.Neutral._100.color
            layer.cornerRadius = intrinsicContentSize.height / 2
            setImage(image, for: .normal)
        }
        
        private func updateAppearance() {
            isHighlighted ? setHighlight() : unsetHighlight()
        }
        
        private func setHighlight() {
            backgroundColor = .Colors.Neutral._200.color
        }
        
        private func unsetHighlight() {
            backgroundColor = .Colors.Neutral._100.color
        }
    }
}
