//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension CardScanningViewController {
    
    final class ContentView: UIView {
        
        // MARK: - Events
        
        private(set) lazy var cardData: Observable<CardNumberDetectionModels.CreditCard> = cardNumberDetector.creditCardData
        private(set) lazy var closeButtonTapped: Observable<Void> = closeButton.tap
        
        // MARK: - Properties
        
        private let cardNumberDetector = CardNumberDetector()
        
        private let detectionArea = DetectionArea()
        private let descriptionLabel = Label.Micro(medium: .Colors.Neutral.white)
        
        private lazy var closeButton: UIButton = {
            let button = Button.Icon(icon: DesignSystem.Icons.close.image)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            button.tintColor = DesignSystem.Colors.Neutral._500.color
            return button
        }()
        
        private let container = UIView()
        
        // MARK: - Initializers
        
        override init(frame: CGRect) {
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

        override func layoutSubviews() {
            super.layoutSubviews()

            updateAppearance()
        }

        // MARK: - API
        
        func startSession() {
            cardNumberDetector.startSession()
        }
        
        func stopSession() {
            cardNumberDetector.stopSession()
        }
        
        // MARK: - Private
        
        private func setupAppearance() {
            backgroundColor = .clear
            descriptionLabel.text = Strings.scanningDescription
            descriptionLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
            descriptionLabel.layer.shadowOffset = .zero
            descriptionLabel.layer.shadowRadius = 8
            descriptionLabel.layer.shadowOpacity = 1
            descriptionLabel.layer.shouldRasterize = true
            descriptionLabel.layer.rasterizationScale = UIScreen.main.scale
        }
        
        private func setupLayout() {
            container.layout
                .add(to: self)
                .embed(in: self)
                .activate()
            
            closeButton.layout
                .add(to: container)
                .bottom.equalTo(container, .bottom).with(constant: -58)
                .trailing.equalTo(container, .trailing).with(constant: -24)
                .activate()
            
            detectionArea.layout
                .add(to: container)
                .height.equalTo(constant: 440)
                .width.equalTo(constant: 276)
                .xAxis.center(with: container)
                .yAxis.center(with: container)
                .top.greaterThanOrEqualTo(self, .top).with(constant: 32)
                .bottom.equalTo(detectionArea, .bottom)
                .activate()
            
            descriptionLabel.layout
                .add(to: container)
                .yAxis.center(with: container)
                .xAxis.center(with: container).with(constant: -152)
                .activate()
            
            descriptionLabel.transform = .init(rotationAngle: .pi / 2)
        }
        
        func updateAppearance() {
            setNeedsLayout()
            cardNumberDetector.set(detectionArea: detectionArea.frame)
            cardNumberDetector.set(videoArea: layer.frame)
            layer.insertSublayer(cardNumberDetector.cameraPreviewLayer, at: 0)
        }
        
        private func observeEvents() {
            cardNumberDetector.cardStatus
                .subscribe(queue: .main, onNext: { [weak self] status in self?.detectionArea.set(status) })
                .add(to: disposer)
            
            detectionArea.retryTapped
                .subscribe(queue: .main, onNext: { [weak self] in self?.cardNumberDetector.startDetection() })
                .add(to: disposer)
        }
    }
}
