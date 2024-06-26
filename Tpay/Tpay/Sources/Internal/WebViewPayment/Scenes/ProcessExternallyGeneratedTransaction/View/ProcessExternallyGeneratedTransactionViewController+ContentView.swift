//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit
import WebKit

extension ProcessExternallyGeneratedTransactionViewController {
    
    final class ContentView: UIView {
        
        // MARK: - Events
        
        var completedWithSuccess: Observable<Void> { tracker.onRedirectToSuccessUrl }
        var completedWithError: Observable<Void> { tracker.onRedirectToErrorUrl }
        
        // MARK: - Properties
        
        private let tracker: WKWebView.RedirectsTracker
                
        private lazy var webView: WKWebView = {
            let webView = WKWebView()
            webView.navigationDelegate = tracker
            return webView
        }()
        
        // MARK: - Initializers
        
        init(successUrl: URL, errorUrl: URL) {
            tracker = WKWebView.RedirectsTracker(successUrl: successUrl, errorUrl: errorUrl)
            super.init(frame: .zero)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) { nil }
        
        // MARK: - Lifecycle
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()

            setupLayout()
        }
        
        // MARK: - API
        
        func load(transactionPaymentUrl: URL) {
            webView.load(.init(url: transactionPaymentUrl))
        }
        
        // MARK: - Private
        
        private func setupLayout() {
            webView.layout
                .add(to: self)
                .embed(in: self)
                .activate()
        }
    }
}
