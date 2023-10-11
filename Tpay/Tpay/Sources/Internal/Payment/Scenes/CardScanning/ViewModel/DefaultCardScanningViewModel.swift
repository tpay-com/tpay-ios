//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultCardScanningViewModel: CardScanningViewModel {
    
    // MARK: - Properties
    
    private let router: CardScanningRouter
    
    // MARK: - Initializers
    
    init(router: CardScanningRouter) {
        self.router = router
    }
    
    // MARK: - API
    
    func close() {
        router.close()
    }
    
    func creditCardScanned(data: CardNumberDetectionModels.CreditCard) {
        router.complete(with: data)
    }
}
