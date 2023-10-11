//
//  Copyright © 2023 Tpay. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, *)
@_documentation(visibility: internal)
extension Payment.SwiftUI {
 
    public struct Button: UIViewRepresentable {
        
        // MARK: - Properties
        
        let action: () -> Void
        
        // MARK: - Initializers
        
        public init(action: @escaping () -> Void) {
            self.action = action
        }
        
        // MARK: - UIViewRepresentable
        
        public func makeUIView(context: Context) -> some UIView {
            let button = Payment.Button()
            button.addTarget(context.coordinator, action: #selector(context.coordinator.buttonTapped), for: .touchUpInside)
            return button
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) { }
        
        public func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        final public class Coordinator: NSObject {
            
            // MARK: - Properties
            
            private let parent: Button
            
            // MARK: - Initializers
            
            init(_ button: Button) {
                self.parent = button
            }
            
            // MARK: - API
            
            @objc func buttonTapped() {
                parent.action()
            }
        }
    }
}

#endif
