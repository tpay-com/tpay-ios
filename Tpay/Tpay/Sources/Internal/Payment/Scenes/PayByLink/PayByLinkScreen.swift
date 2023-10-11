//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayByLinkScreen: Screen {
    
    // MARK: - Properties
    
    let viewController: UIViewController
    let router: PayByLinkRouter
    
    // MARK: - Initialization
    
    init(for transaction: Domain.Transaction, using resolver: ServiceResolver) {
        router = DefaultPayByLinkRouter()
        let model = DefaultPayByLinkModel(for: transaction, using: resolver)
        let viewModel = DefaultPayByLinkViewModel(model: model, router: router)
        viewController = PayByLinkViewController(with: viewModel)
    }
}
