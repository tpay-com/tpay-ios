//
//  Copyright © 2023 Tpay. All rights reserved.
//

enum ApplePayStatus {
    
    // MARK: - Cases
    
    case success(transaction: Domain.OngoingTransaction)
    case failure(error: Error)
    case notAuthorized
}
