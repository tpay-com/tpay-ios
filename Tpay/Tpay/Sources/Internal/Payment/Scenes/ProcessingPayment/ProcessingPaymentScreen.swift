//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ProcessingPaymentScreen: Screen {
    
    // MARK: - Properties
    
    let viewController: UIViewController
    let router: ProcessingPaymentRouter
 
    // MARK: - Initializers
    
    init(for transaction: Domain.OngoingTransaction, using resolver: ServiceResolver) {
        router = DefaultProcessingPaymentRouter()
        let model = DefaultProcessingPaymentModel(transaction: transaction, resolver: resolver)
        let viewModel = DefaultProcessingPaymentViewModel(title: Strings.processingPaymentTitle, message: Strings.processingPaymentMessage, model: model, router: router)
        viewController = ProcessingPaymentViewController(with: viewModel)
    }
}
