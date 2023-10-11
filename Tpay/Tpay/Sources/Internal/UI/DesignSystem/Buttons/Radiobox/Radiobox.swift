//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Button {
    
    final class Radiobox: UIButton {
        
        // MARK: - Properties
        
        override var intrinsicContentSize: CGSize {
            CGSize(width: 24, height: 24)
        }
        
        override var isHighlighted: Bool {
            didSet {
                updateAppearance()
            }
        }
        
        override var isSelected: Bool {
            didSet {
                updateAppearance()
            }
        }
        
        private let dot: UIView = {
            let view = UIView()
            view.backgroundColor = DesignSystem.Colors.Primary._500.color
            view.layer.cornerRadius = Constants.dotSize.height / 2
            view.isUserInteractionEnabled = false
            return view
        }()
        
        // MARK: - Initializers
        
        init() {
            super.init(frame: .zero)
            
            setupAppearance()
            setupActions()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            setupLayout()
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            layer.cornerRadius = intrinsicContentSize.width / 2
            layer.borderWidth = Constants.borderWidth
            layer.borderColor = DesignSystem.Colors.Neutral._200.color.cgColor
            backgroundColor = .white
        }
        
        private func setupActions() {
            addTarget(self, action: #selector(changeSelection), for: .touchUpInside)
        }
        
        private func setupLayout() {
            dot.center = CGPoint(x: bounds.midX, y: bounds.midY)
            dot.layer.frame.size = Constants.dotSize
        }
        
        private func updateAppearance() {
            isSelected ? setSelected() : unsetSelected()
            isHighlighted ? setHighlight() : unsetHighlight()
        }
        
        private func setHighlight() {
            if isSelected {
                dot.backgroundColor = DesignSystem.Colors.Primary._600.color
                layer.borderColor = DesignSystem.Colors.Primary._600.color.cgColor
            } else {
                layer.borderColor = DesignSystem.Colors.Neutral._300.color.cgColor
            }
        }
        
        private func unsetHighlight() {
            if isSelected {
                dot.backgroundColor = DesignSystem.Colors.Primary._500.color
                layer.borderColor = DesignSystem.Colors.Primary._500.color.cgColor
            } else {
                layer.borderColor = DesignSystem.Colors.Neutral._200.color.cgColor
            }
        }
        
        private func setSelected() {
            dot.backgroundColor = DesignSystem.Colors.Primary._500.color
            layer.borderColor = DesignSystem.Colors.Primary._500.color.cgColor
            addSubview(dot)
        }
        
        private func unsetSelected() {
            
            layer.borderColor = DesignSystem.Colors.Neutral._200.color.cgColor
            dot.removeFromSuperview()
        }
        
        @objc private func changeSelection() {
            isSelected.toggle()
        }
    }
}
