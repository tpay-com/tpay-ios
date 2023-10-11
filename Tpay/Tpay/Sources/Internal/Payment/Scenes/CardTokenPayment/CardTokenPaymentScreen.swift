//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class CardTokenPaymentScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: CardTokenPaymentRouter
    
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, with cardToken: Domain.CardToken, using resolver: ServiceResolver) {
        router = DefaultCardTokenPaymentRouter()
        let model = DefaultCardTokenPaymentModel(for: transaction, with: cardToken, using: resolver)
        let viewModel = DefaultCardTokenPaymentViewModel(title: Strings.processingPaymentTitle,
                                                         message: Strings.processingPaymentMessage,
                                                         model: model,
                                                         router: router)
        viewController = CardTokenPaymentViewController(with: viewModel)
    }
}
