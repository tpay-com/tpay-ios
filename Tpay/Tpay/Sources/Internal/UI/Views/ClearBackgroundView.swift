//
//  Copyright © 2023 Tpay. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, *)
struct ClearBackgroundView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    private class InnerView: UIView {
        
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
    }
}

#endif
