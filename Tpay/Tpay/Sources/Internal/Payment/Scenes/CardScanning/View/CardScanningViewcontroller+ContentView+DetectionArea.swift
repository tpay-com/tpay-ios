//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension CardScanningViewController.ContentView {
    
    final class DetectionArea: UIView {
        
        // MARK: - Events
        
        private(set) lazy var retryTapped = retryButton.tap
        
        // MARK: - Properties
        
        private let line = CAShapeLayer()
        
        private let descriptionContainer = UIView()
        
        private let loader = ComplexBackgroundLoader()
        private let descriptionLabel = Label.H2(DesignSystem.Colors.Neutral.white)
        private let retryButton = Button.Primary()
        
        private var status: CardScanningStatus = .documentOutOfRange {
            didSet {
                updateAppearance()
            }
        }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            setupAppearance()
            setupLayout()
        }
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)

            drawArea()
        }
        
        // MARK: - API
        
        func set(_ status: CardScanningStatus) {
            self.status = status
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            loader.layout
                .add(to: self)
                .yAxis.center(with: self)
                .xAxis.center(with: self)
                .activate()
        
            descriptionContainer.layout
                .add(to: self)
                .xAxis.center(with: self)
                .yAxis.center(with: self)
                .activate()
            
            descriptionLabel.layout
                .add(to: descriptionContainer)
                .top.equalTo(descriptionContainer, .top).with(constant: 8)
                .bottom.equalTo(descriptionContainer, .bottom).with(constant: -8)
                .yAxis.center(with: self)
                .leading.equalTo(descriptionContainer, .leading).with(constant: 16)
                .trailing.equalTo(descriptionContainer, .trailing).with(constant: -16)
                .activate()
            
            retryButton.layout
                .add(to: self)
                .yAxis.center(with: self)
                .xAxis.center(with: self).with(constant: -58)
                .activate()
            
            descriptionContainer.transform = .init(rotationAngle: .pi / 2)
            retryButton.transform = .init(rotationAngle: .pi / 2)
        }
        
        private func setupAppearance() {
            backgroundColor = .clear
            descriptionContainer.backgroundColor = DesignSystem.Colors.Neutral._900.color.withAlphaComponent(0.5)
            descriptionContainer.layer.cornerRadius = 13
            retryButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 33, bottom: 14, right: 33)
            retryButton.setTitle(Strings.tryAgain, for: .normal)
            
            updateAppearance()
        }
        
        private func updateAppearance() {
            switch status {
            case .documentInRange:
                line.strokeColor = DesignSystem.Colors.Semantic.success.color.cgColor
                loader.isHidden = false
                descriptionContainer.isHidden = true
                retryButton.isHidden = true
            case .documentOutOfRange:
                line.strokeColor = DesignSystem.Colors.Neutral.white.color.cgColor
                loader.isHidden = true
                descriptionContainer.isHidden = false
                descriptionLabel.text = Strings.putCardInDetectionArea
                retryButton.isHidden = true
            case .failed:
                line.strokeColor = DesignSystem.Colors.Semantic.error.color.cgColor
                loader.isHidden = true
                descriptionContainer.isHidden = false
                descriptionLabel.text = Strings.scanningError
                retryButton.isHidden = false
            }
        }
        
        private func drawArea() {
            let detectionAreaPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
            line.path = detectionAreaPath.cgPath
            line.strokeColor = DesignSystem.Colors.Neutral.white.color.cgColor
            line.fillColor = UIColor.clear.cgColor
            line.lineWidth = 2.0

            let shadowSubLayer = createShadowLayer()
            shadowSubLayer.insertSublayer(line, at: 0)
            layer.addSublayer(shadowSubLayer)
        }
        
        private func createShadowLayer() -> CALayer {
            let shadowLayer = CALayer()
            shadowLayer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
            shadowLayer.shadowOffset = CGSize.zero
            shadowLayer.shadowRadius = 2.0
            shadowLayer.shadowOpacity = 1
            shadowLayer.backgroundColor = UIColor.clear.cgColor
            return shadowLayer
        }
    }
}
