//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ProcessingPaymentWithUrlScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: ProcessingPaymentWithUrlRouter
        
    // MARK: - Initializers
    
    init(for transaction: Domain.OngoingTransaction, using resolver: ServiceResolver) {
        router = DefaultProcessingPaymentWithUrlRouter()
        let model = DefaultProcessingPaymentWithUrlModel(transaction: transaction, resolver: resolver)
        let viewModel = DefaultProcessingPaymentWithUrlViewModel(model: model, router: router)        
        viewController = ProcessingPaymentWithUrlViewController(with: viewModel)
    }
}
