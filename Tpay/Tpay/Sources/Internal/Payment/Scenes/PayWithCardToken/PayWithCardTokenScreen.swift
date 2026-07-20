//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithCardTokenScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: PayWithCardTokenRouter
        
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, with cardTokens: [Domain.CardToken], using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        router = DefaultPayWithCardTokenRouter()
        let model = DefaultPayWithCardTokenModel(for: transaction, with: cardTokens, using: resolver, transactionLock: transactionLock)
        let viewModel = DefaultPayWithCardTokenViewModel(model: model, router: router)        
        viewController = PayWithCardTokenViewController(with: viewModel)
    }
}
