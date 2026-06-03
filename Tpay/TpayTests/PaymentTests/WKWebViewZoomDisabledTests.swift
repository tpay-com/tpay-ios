//
//  Copyright © 2026 Tpay. All rights reserved.
//

import WebKit
import XCTest

@testable import Tpay

// Regression test for TPAY-97: PayPo (and other provider) pages auto-zoomed
// when the verification-code input received focus on small iPhones.
//
// iOS triggers that focus-zoom only when the focused form control renders
// below 16px. `WKWebView.zoomDisabled()` injects a stylesheet forcing form
// controls to >= 16px, which is the exact condition that suppresses the zoom.
//
// We can't drive the OS-level zoom gesture from a unit test, but we can prove
// the precondition deterministically in real WebKit: load a PayPo-shaped page
// (zoomable viewport + a sub-16px input) and assert the rendered font-size.
final class WKWebViewZoomDisabledTests: XCTestCase {

    // Mirrors PayPo: a viewport without `maximum-scale` and an input whose
    // own (high-specificity) rule sets a sub-16px font.
    private let payPoLikeHTML = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>#code { font-size: 12px; }</style>
    </head>
    <body>
        <input id="code" type="text" inputmode="numeric" />
    </body>
    </html>
    """

    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        window.isHidden = true
        window = nil
        super.tearDown()
    }

    func testZoomDisabledForcesInputFontToAtLeast16px() {
        let webView = WKWebView.zoomDisabled()
        let fontSize = renderedInputFontSize(in: webView)
        XCTAssertEqual(fontSize, 16, accuracy: 0.5,
                       "zoomDisabled() must render the input at >= 16px so iOS skips focus-zoom; got \(fontSize)px")
    }

    func testPlainWebViewLeavesInputBelow16px() {
        // Control: a vanilla WKWebView keeps the page's 12px → would focus-zoom.
        // Guards against the fix silently no-op'ing and the test passing anyway.
        let webView = WKWebView()
        let fontSize = renderedInputFontSize(in: webView)
        XCTAssertEqual(fontSize, 12, accuracy: 0.5,
                       "control should keep the page font; got \(fontSize)px")
    }

    func testScrollViewZoomIsLocked() {
        let webView = WKWebView.zoomDisabled()
        XCTAssertEqual(webView.scrollView.minimumZoomScale, 1.0)
        XCTAssertEqual(webView.scrollView.maximumZoomScale, 1.0)
        XCTAssertFalse(webView.scrollView.bouncesZoom)
    }

    // MARK: - Helpers

    private func renderedInputFontSize(in webView: WKWebView) -> Double {
        webView.frame = window.bounds
        window.addSubview(webView)

        let loaded = expectation(description: "page loaded")
        let delegate = NavigationFinishedDelegate { loaded.fulfill() }
        webView.navigationDelegate = delegate
        webView.loadHTMLString(payPoLikeHTML, baseURL: nil)
        wait(for: [loaded], timeout: 10)

        let measured = expectation(description: "font measured")
        var result = Double.nan
        webView.evaluateJavaScript(
            "parseFloat(getComputedStyle(document.getElementById('code')).fontSize)"
        ) { value, _ in
            if let number = value as? NSNumber { result = number.doubleValue }
            measured.fulfill()
        }
        wait(for: [measured], timeout: 10)

        webView.removeFromSuperview()
        return result
    }

    private final class NavigationFinishedDelegate: NSObject, WKNavigationDelegate {
        private let onFinish: () -> Void
        init(onFinish: @escaping () -> Void) { self.onFinish = onFinish }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { onFinish() }
    }
}
