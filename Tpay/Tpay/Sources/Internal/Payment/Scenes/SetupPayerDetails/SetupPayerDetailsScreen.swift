//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class SetupPayerDetailsScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: SetupPayerDetailsRouter
    
    private let viewModel: SetupPayerDetailsViewModel
    
    // MARK: - Initializers
    
    init(for transaction: Transaction, using resolver: ServiceResolver, payerOverride: Domain.Payer? = nil) {
        router = DefaultSetupPayerDetailsRouter()
        let model = DefaultSetupPayerDetailsModel(transaction: transaction, using: resolver)
        viewModel = DefaultSetupPayerDetailsViewModel(model: model, router: router, payerOverride: payerOverride)
        
        viewController = SetupPayerDetailsViewController(with: viewModel)
        viewController.title = Strings.setupPayerDetailsHeadline
    }
}
