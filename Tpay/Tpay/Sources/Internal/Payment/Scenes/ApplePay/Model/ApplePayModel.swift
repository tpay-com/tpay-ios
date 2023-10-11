//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit

protocol ApplePayModel: AnyObject {
    
    // MARK: - API
    
    func paymentRequest(for transaction: Domain.Transaction) -> PKPaymentRequest
}
