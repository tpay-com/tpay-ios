//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

final class PayWithRatyPekaoScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: PayWithRatyPekaoRouter
        
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, using resolver: ServiceResolver, transactionLock: SingleTransactionLock) {
        router = DefaultPayWithRatyPekaoRouter()
        let model = DefaultPayWithRatyPekaoModel(for: transaction, using: resolver, transactionLock: transactionLock)
        let viewModel = DefaultPayWithRatyPekaoViewModel(model: model, router: router)        
        viewController = PayWithRatyPekaoViewController(with: viewModel)
    }
}
