//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol DigitalWalletService: AnyObject {
    
    // MARK: - Properties
    
    var digitalWallets: [Domain.PaymentMethod.DigitalWallet] { get }
    
}
