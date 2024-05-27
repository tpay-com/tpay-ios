//
//  Copyright © 2024 Tpay. All rights reserved.
//

import UIKit

final class ProcessExternallyGeneratedTransactionScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: ProcessExternallyGeneratedTransactionRouter
        
    // MARK: - Initializers
    
    init(for transaction: ExternallyGeneratedTransaction) {
        router = DefaultProcessExternallyGeneratedTransactionRouter()
        let model = DefaultProcessExternallyGeneratedTransactionModel(transaction: transaction)
        let viewModel = DefaultProcessExternallyGeneratedTransactionViewModel(model: model, router: router)        
        viewController = ProcessExternallyGeneratedTransactionViewController(with: viewModel)
    }
}
