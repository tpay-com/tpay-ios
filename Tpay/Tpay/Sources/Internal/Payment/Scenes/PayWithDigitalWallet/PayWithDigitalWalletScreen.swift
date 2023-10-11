//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class PayWithDigitalWalletScreen: Screen {
    
    // MARK: - Properties
    
    let viewController: UIViewController
    let router: PayWithDigitalWalletRouter
    
    // MARK: - Initialization
    
    init(for transaction: Domain.Transaction, using resolver: ServiceResolver) {
        router = DefaultPayWithDigitalWalletRouter()
        let model = DefaultPayWithDigitalWalletModel(for: transaction, using: resolver)
        let viewModel = DefaultPayWithDigitalWalletsViewModel(model: model, router: router)
        viewController = PayWithDigitalWalletViewController(with: viewModel)
    }
}
