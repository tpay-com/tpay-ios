//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultDigitalWalletService: DigitalWalletService {
    
    // MARK: - Properties
    
    private(set) lazy var digitalWallets: [Domain.PaymentMethod.DigitalWallet] = paymentDataStore.paymentMethods.allWallets()
    
    private let paymentDataStore: PaymentDataStore
    
    // MARK: - Initializers
    
    convenience init(resolver: ServiceResolver) {
        self.init(paymentDataStore: resolver.resolve())
    }
    
    init(paymentDataStore: PaymentDataStore) {
        self.paymentDataStore = paymentDataStore
    }
}
