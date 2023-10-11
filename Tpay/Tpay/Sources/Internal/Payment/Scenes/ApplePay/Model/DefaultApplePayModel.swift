//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit

final class DefaultApplePayModel: ApplePayModel {
    
    // MARK: - Properties
    
    private let applePayService: ApplePayService
    
    // MARK: - Initializers
    
    convenience init?(using resolver: ServiceResolver) {
        guard let applePayService = DefaultApplePayService(using: resolver) else { return nil }
        self.init(applePayService: applePayService)
    }
    
    init(applePayService: ApplePayService) {
        self.applePayService = applePayService
    }
    
    // MARK: - API
    
    func paymentRequest(for transaction: Domain.Transaction) -> PKPaymentRequest {
        applePayService.paymentRequest(for: transaction)
    }
}
