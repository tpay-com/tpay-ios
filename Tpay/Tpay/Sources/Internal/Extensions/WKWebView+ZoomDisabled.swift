//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {

    // Some payment provider pages (e.g. PayPo verification code) auto-zoom
    // on input focus when the page's own viewport allows it. We override
    // the viewport meta and lock the scrollView so the embedded page stays
    // at scale 1 regardless of the provider's own settings.
    static func zoomDisabled() -> WKWebView {
        let viewportScript = WKUserScript(
            source: """
            var meta = document.createElement('meta');
            meta.setAttribute('name', 'viewport');
            meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
            document.getElementsByTagName('head')[0].appendChild(meta);
            """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(viewportScript)

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
        webView.scrollView.bouncesZoom = false
        return webView
    }
}
