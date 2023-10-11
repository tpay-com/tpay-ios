//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit

protocol PayWithDigitalWalletModel: AnyObject {
    
    // MARK: - Properties
    
    var digitalWallets: [Domain.PaymentMethod.DigitalWallet] { get }
    var transaction: Domain.Transaction { get }
    
    // MARK: - API
    
    func payWithApplePay(with token: Domain.ApplePayToken, then: @escaping OngoingTransactionResultHandler)
}
