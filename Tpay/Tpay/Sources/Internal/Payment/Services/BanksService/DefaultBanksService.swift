//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultBanksService: BanksService {
    
    // MARK: - Properties
    
    var banks: [Domain.PaymentMethod.Bank] { paymentDataStore.paymentMethods.allBanks() }
    
    private let paymentDataStore: PaymentDataStore
    
    // MARK: - Initializers
    
    convenience init(resolver: ServiceResolver) {
        self.init(paymentDataStore: resolver.resolve())
    }
    
    init(paymentDataStore: PaymentDataStore) {
        self.paymentDataStore = paymentDataStore
    }
    
}
