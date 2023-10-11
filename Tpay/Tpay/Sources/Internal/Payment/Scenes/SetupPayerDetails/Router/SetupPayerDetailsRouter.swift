//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol SetupPayerDetailsRouter: AnyObject {
    
    // MARK: - Events
    
    var onSetup: Observable<Domain.Payer> { get }
}

extension SetupPayerDetailsRouter {
    
    // MARK: - API
    
    func setup(payer details: Domain.Payer) {
        onSetup.on(.next(details))
    }
}
