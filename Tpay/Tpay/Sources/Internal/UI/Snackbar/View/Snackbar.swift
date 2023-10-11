//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

class Snackbar: UIView {
    
    // MARK: - Events
    
    let countdownFinished = Observable<Void>()
    
    // MARK: - Properties

    private let color: UIColor
    private let message: String
    private let interval: TimeInterval
    
    private lazy var label = Label.BodySmall.Builder(label: Label.BodySmall())
        .set(text: message)
        .set(color: DesignSystem.Color.Colors.Neutral.white)
        .set(numberOfLines: 2)
        .set(textAlignment: .center)
        .build()
    
    private let progress = Progress()

    // MARK: - Initializers
    
    init(color: UIColor, message: String, countdown interval: TimeInterval = Constants.timeout) {
        self.color = color
        self.message = message
        self.interval = interval
        
        super.init(frame: .zero)
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupLayout()
        setupAppearance()
        setupComponents()
    }
    
    // MARK: - API
    
    func startCountdown() {
        progress.setProgress(0, animated: false)
        UIView.animate(withDuration: self.interval,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in self?.progress.layoutIfNeeded() },
                       completion: { [weak self] _ in self?.countdownFinished.on(.next(())) })
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        label.layout
            .add(to: self)
            .leading.equalTo(self, .leading).with(constant: 16)
            .trailing.equalTo(self, .trailing).with(constant: -16)
            .top.equalTo(self, .top).with(constant: 16)
            .bottom.equalTo(self, .bottom).with(constant: -16)
            .activate()
        
        progress.layout
            .add(to: self)
            .leading.equalTo(label, .leading)
            .trailing.equalTo(label, .trailing)
            .bottom.equalTo(self, .bottom)
            .activate()
    }
    
    private func setupAppearance() {
        backgroundColor = color
        
        layer.masksToBounds = true
        layer.cornerRadius = 13
    }
    
    private func setupComponents() {
        progress.setProgress(1, animated: false)
    }
}

private extension Snackbar {
    
    enum Constants {
        
        // MARK: - Properties
        
        static let timeout: TimeInterval = 4
    }
}
