//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class ProcessingTokenizationWithUrlScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: ProcessingTokenizationWithUrlRouter
        
    // MARK: - Initializers
    
    init(for tokenization: Domain.OngoingTokenization, using resolver: ServiceResolver) {
        router = DefaultProcessingTokenizationWithUrlRouter()
        let model = DefaultProcessingTokenizationWithUrlModel(tokenization: tokenization, resolver: resolver)
        let viewModel = DefaultProcessingTokenizationWithUrlViewModel(model: model, router: router)        
        viewController = ProcessingTokenizationWithUrlViewController(with: viewModel)
    }
}
