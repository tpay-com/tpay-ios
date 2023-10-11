//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Snackbar {
    
    // MARK: - Factories
        
    static func make(for snack: Snack) -> Snackbar {
        switch snack.kind {
        case .error:
            return Snackbar.Error(message: snack.message)
        }
    }
}
