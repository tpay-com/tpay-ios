//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class FailureScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: FailureRouter
        
    // MARK: - Initializers
    
    init(content: FailureContent) {
        router = DefaultFailureRouter()
        let viewModel = DefaultFailureViewModel(content: content, router: router)
        viewController = FailureViewController(with: viewModel)
    }
}
