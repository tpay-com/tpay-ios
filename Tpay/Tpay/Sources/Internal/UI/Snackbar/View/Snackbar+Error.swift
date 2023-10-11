//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Snackbar {
    
    final class Error: Snackbar {
        
        // MARK: - Initializers
        
        init(message: String) {
            super.init(color: Asset.Colors.Semantic.error.color, message: message)
        }
    }
}
