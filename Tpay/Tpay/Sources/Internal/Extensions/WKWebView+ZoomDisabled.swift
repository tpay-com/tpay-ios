//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {

    // Some payment provider pages (e.g. PayPo's SMS verification code, rendered
    // as several small one-digit OTP inputs) auto-zoom when a field gets focus.
    // iOS triggers this whenever a focused editable control has a font-size
    // below 16px and the viewport does not pin `maximum-scale`.
    //
    // The 1.3.18 workaround appended a `<meta viewport>` tag, but WKWebView only
    // evaluates the viewport during the initial parse, so it was ignored on real
    // devices.
    //
    // This fix raises only the fields that would trigger the zoom — i.e. those
    // whose computed font-size is below 16px — up to exactly 16px (the documented
    // threshold at which iOS stops focus-zooming). Fields that are already >= 16px
    // are left untouched, so the provider's own layout is not altered beyond the
    // minimum needed to stop the zoom. The size is applied as an INLINE
    // `!important` style so a high-specificity provider rule cannot override it.
    // A focusin handler and a MutationObserver cover fields focused or added
    // after load.
    static func zoomDisabled() -> WKWebView {
        let script = WKUserScript(
            source: """
            (function() {
                var SEL = 'input, select, textarea, [contenteditable]';
                function bumpIfBelow16(el) {
                    try {
                        if (!el || !el.style) { return; }
                        var fs = parseFloat(window.getComputedStyle(el).fontSize);
                        if (!isNaN(fs) && fs < 16) {
                            el.style.setProperty('font-size', '16px', 'important');
                        }
                    } catch (e) {}
                }
                function applyAll() {
                    var fields = document.querySelectorAll(SEL);
                    for (var i = 0; i < fields.length; i++) { bumpIfBelow16(fields[i]); }
                }
                applyAll();
                document.addEventListener('focusin', function(e) { bumpIfBelow16(e.target); }, true);
                try {
                    new MutationObserver(applyAll)
                        .observe(document.documentElement, { childList: true, subtree: true });
                } catch (e) {}
            })();
            """,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )

        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(script)

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
        webView.scrollView.bouncesZoom = false
        return webView
    }
}
