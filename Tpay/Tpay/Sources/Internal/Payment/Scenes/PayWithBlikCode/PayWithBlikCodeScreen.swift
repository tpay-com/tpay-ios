//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithBlikCodeScreen: Screen {
    
    // MARK: - Properties
    
    let viewController: UIViewController
    let router: PayWithBlikCodeRouter
    
    // MARK: - Initialization
    
    init(for transaction: Domain.Transaction, using resolver: ServiceResolver, isNavigationToOneClickEnabled: Bool) {
        router = DefaultPayWithBlikCodeRouter()
        let model = DefaultPayWithBlikCodeModel(using: resolver)
        let viewModel = DefaultPayWithBlikCodeViewModel(for: transaction, model: model, router: router, isNavigationToOneClickEnabled: isNavigationToOneClickEnabled)
        viewController = PayWithBlikCodeViewController(with: viewModel)
    }
}
