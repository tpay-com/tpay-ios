//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension Button {
    
    final class Primary: UIButton {
                
        // MARK: - Properties
                
        override var intrinsicContentSize: CGSize {
            CGSize(width: super.intrinsicContentSize.width, height: Constants.height)
        }
        
        override var isHighlighted: Bool {
            didSet {
                guard oldValue != isHighlighted else { return }
                updateAppearance()
            }
        }
        
        override var isEnabled: Bool {
            didSet {
                guard oldValue != isEnabled else { return }
                updateAppearance()
            }
        }
        
        private var occupationState: OccupationState = .idle
        
        private let loader = Loader(style: .default)
                
        // MARK: - Initializers
        
        init() {
            super.init(frame: .zero)
            setupAppearance()
            prepareForReuse()
        }
        
        required init?(coder: NSCoder) { nil }
        
        // MARK: - API
        
        func prepareForReuse() {
            setTitle(nil, for: .normal)
            backgroundColor = .Colors.Primary._500.color
            setTitleColor(.Colors.Neutral.white.color, for: .normal)
        }
        
        func set(occupationState: OccupationState) {
            self.occupationState = occupationState
            updateAppearance()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            round(.allCorners, by: 24)
            
            let loaderSize = loader.intrinsicContentSize
            let loaderOrigin = CGPoint(x: (bounds.width - loaderSize.width) / 2,
                                       y: (bounds.height - loaderSize.height) / 2)
            loader.frame = CGRect(origin: loaderOrigin, size: loaderSize)
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            addSubview(loader)

            titleLabel?.font = DesignSystem.Font.medium.font(size: 15)
            setIdle()
        }
        
        private func updateAppearance() {
            guard isEnabled else {
                setDisabled()
                return
            }
            
            switch occupationState {
            case .busy:
                setBusy()
            case .idle:
                setIdle()
            }
            
            isHighlighted ? setHighlight() : unsetHighlight()
        }
        
        private func setHighlight() {
            backgroundColor = .Colors.Primary._600.color
        }
        
        private func unsetHighlight() {
            backgroundColor = .Colors.Primary._500.color
        }
        
        private func setDisabled() {
            backgroundColor = .Colors.Neutral._200.color
        }
        
        private func setBusy() {
            titleLabel?.layer.opacity = 0

            loader.startAnimation()
            loader.show()
            isUserInteractionEnabled = false
        }
        
        private func setIdle() {
            titleLabel?.layer.opacity = 1

            loader.stopAnimation()
            loader.hide()
            isUserInteractionEnabled = true
        }
    }
}

private extension Button.Primary {
    
    enum Constants {
        
        // MARK: - Properties
        
        static let height: CGFloat = 48
    }
}
