//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension SnackbarViewController {
    
    final class ContentView: UIView {
        
        // MARK: - Events
        
        var countdownFinished: Observable<Void> { snackbar.countdownFinished }
        
        // MARK: - Properties
        
        private let snackbar: Snackbar
        
        // MARK: - Initializers
        
        init(snack: Snack) {
            self.snackbar = Snackbar.make(for: snack)
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToWindow()
            
            setupLayout()
        }
        
        // MARK: - API
        
        func startCountdown() {
            snackbar.startCountdown()
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            snackbar.layout
                .add(to: self)
                .width.lessThanOrEqualTo(self, .width).multiplied(by: 0.75)
                .xAxis.center(with: self)
                .bottom.equalTo(safeAreaLayoutGuide, .bottom).with(constant: -16)
                .activate()
        }
    }
}
