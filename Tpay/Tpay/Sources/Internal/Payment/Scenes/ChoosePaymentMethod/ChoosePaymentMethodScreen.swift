//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ChoosePaymentMethodScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: ChoosePaymentMethodRouter
    
    private let viewModel: ChoosePaymentMethodViewModel
        
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, using resolver: ServiceResolver) {
        router = DefaultChoosePaymentMethodRouter()
        viewModel = DefaultChoosePaymentMethodViewModel(model: DefaultChoosePaymentMethodModel(for: transaction, using: resolver),
                                                        router: router)
        viewController = ChoosePaymentMethodViewController(with: viewModel)
        viewController.title = Strings.paymentMethodHeadline
    }
    
    // MARK: - API
    
    func present(sub scene: Screen) {
        (viewController as? ChoosePaymentMethodViewController)?.set(payment: scene.viewController)
    }
}
