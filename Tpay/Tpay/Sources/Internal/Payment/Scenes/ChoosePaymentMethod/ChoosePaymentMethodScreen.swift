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
    
    init(using resolver: ServiceResolver) {
        router = DefaultChoosePaymentMethodRouter()
        viewModel = DefaultChoosePaymentMethodViewModel(model: DefaultChoosePaymentMethodModel(using: resolver),
                                                        router: router)
        viewController = ChoosePaymentMethodViewController(with: viewModel)
        viewController.title = Strings.paymentMethodHeadline
    }
    
    // MARK: - API
    
    func present(sub scene: Screen) {
        (viewController as? ChoosePaymentMethodViewController)?.set(payment: scene.viewController)
    }
}
