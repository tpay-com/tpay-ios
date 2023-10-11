//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Button {
    
    final class Checkbox: UIButton {
        
        // MARK: - Events
        
        let selectionChanged = Observable<Bool>()
        
        // MARK: - Properties
                
        override var intrinsicContentSize: CGSize {
            CGSize(width: 24, height: 24)
        }
        
        override var isHighlighted: Bool {
            didSet {
                guard oldValue != isHighlighted else { return }
                updateAppearance()
            }
        }
        
        override var isSelected: Bool {
            didSet {
                guard oldValue != isSelected else { return }
                updateAppearance()
            }
        }
        
        // MARK: - Lifecycle

        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupAppearance()
            setupActions()
        }
        
        // MARK: - API
        
        func toggleSelection() {
            changeSelection()
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            layer.cornerRadius = Constants.cornerRadius
            layer.borderWidth = Constants.borderWidth
            layer.borderColor = DesignSystem.Colors.Neutral._200.color.cgColor
            backgroundColor = .white
            
            let checkIcon = DesignSystem.Icons.check.image
                .scalePreservingAspectRatio(targetSize: .init(width: 12, height: 9))
                .withRenderingMode(.alwaysTemplate)
            setImage(checkIcon, for: .selected)
            setImage(checkIcon, for: [.selected, .highlighted])
            tintColor = .Colors.Neutral.white.color
        }
        
        private func setupActions() {
            addTarget(self, action: #selector(changeSelection), for: .touchUpInside)
        }
        
        private func updateAppearance() {
            isSelected ? setSelected() : unsetSelected()
            isHighlighted ? setHighlight() : unsetHighlight()
        }
        
        private func setHighlight() {
            if isSelected {
                backgroundColor = DesignSystem.Colors.Primary._600.color
                layer.borderColor = DesignSystem.Colors.Primary._600.color.cgColor
            } else {
                layer.borderColor = DesignSystem.Colors.Neutral._300.color.cgColor
            }
        }
        
        private func unsetHighlight() {
            if isSelected {
                backgroundColor = DesignSystem.Colors.Primary._500.color
                layer.borderColor = DesignSystem.Colors.Primary._500.color.cgColor
            } else {
                layer.borderColor = DesignSystem.Colors.Neutral._200.color.cgColor
            }
        }
        
        private func setSelected() {
            backgroundColor = DesignSystem.Colors.Primary._500.color
            layer.borderColor = DesignSystem.Colors.Primary._500.color.cgColor
        }
        
        private func unsetSelected() {
            backgroundColor = .white
            layer.borderColor = DesignSystem.Colors.Neutral._200.color.cgColor
        }
        
        @objc private func changeSelection() {
            isSelected.toggle()
            selectionChanged.on(.next(isSelected))
        }
    }
}
