//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithAmbiguousBlikAliasesScreen: Screen {
    
    // MARK: - Properties
    
    let viewController: UIViewController
    let router: PayWithAmbiguousBlikAliasesRouter
    
    // MARK: - Initialization
    
    init(for ongoingTransaction: Domain.OngoingTransaction,
         with blikAliases: [Domain.Blik.OneClick.Alias],
         transactionDetails: Domain.Transaction,
         using resolver: ServiceResolver) {
        router = DefaultPayWithAmbiguousBlikAliasesRouter()
        let model = DefaultPayWithAmbiguousBlikAliasesModel(for: ongoingTransaction,
                                                            with: blikAliases,
                                                            transactionDetails: transactionDetails,
                                                            using: resolver)
        let viewModel = DefaultPayWithAmbiguousBlikAliasesViewModel(model: model, router: router)
        viewController = PayWithAmbiguousBlikAliasesViewController(with: viewModel)
    }
}
