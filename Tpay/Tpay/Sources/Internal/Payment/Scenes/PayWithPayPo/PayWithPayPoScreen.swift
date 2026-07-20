//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

final class PayWithPayPoScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: PayWithPayPoRouter
        
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        router = DefaultPayWithPayPoRouter()
        let model = DefaultPayWithPayPoModel(for: transaction, using: resolver, transactionLock: transactionLock)
        let viewModel = DefaultPayWithPayPoViewModel(model: model, router: router)        
        viewController = PayWithPayPoViewController(with: viewModel)
    }
}
