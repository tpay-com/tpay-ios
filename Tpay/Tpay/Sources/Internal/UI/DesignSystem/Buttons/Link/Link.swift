//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Button {
    
    final class Link: UIButton {
        
        // MARK: - Properties
        
        override var isHighlighted: Bool {
            didSet {
                guard oldValue != isHighlighted else { return }
                updateAppearance()
            }
        }
        
        // MARK: - Initializers
        
        init() {
            super.init(frame: .zero)
            setupAppearance()
            prepareForReuse()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - API
        
        func prepareForReuse() {
            setTitle(nil, for: .normal)
            setTitleColor(.Colors.Primary._500.color, for: .normal)
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            titleLabel?.font = DesignSystem.Font.medium.font(size: 15)
            setTitleColor(.Colors.Primary._500.color, for: .normal)
        }
        
        private func updateAppearance() {
            isHighlighted ? setHighlight() : unsetHighlight()
        }
        
        private func setHighlight() {
            setTitleColor(.Colors.Primary._600.color, for: .normal)
        }
        
        private func unsetHighlight() {
            setTitleColor(.Colors.Primary._500.color, for: .normal)
        }
    }
}
