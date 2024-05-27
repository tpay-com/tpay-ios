//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {

    class RedirectsTracker: NSObject {
        
        // MARK: - Events
        
        let onRedirectToSuccessUrl = Observable<Void>()
        let onRedirectToErrorUrl = Observable<Void>()
        
        // MARK: - Properties
        
        private let successUrl: URL
        private let errorUrl: URL
        
        // MARK: - Initialziers
        
        init(successUrl: URL, errorUrl: URL) {
            self.successUrl = successUrl
            self.errorUrl = errorUrl
        }
    }
}

extension WKWebView.RedirectsTracker: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        switch navigationResponse.response.url?.normalized {
        case .some(successUrl.normalized):
            onRedirectToSuccessUrl.on(.next(()))
            decisionHandler(.cancel)
        case .some(errorUrl.normalized):
            onRedirectToErrorUrl.on(.next(()))
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
}
