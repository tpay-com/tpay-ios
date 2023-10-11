//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class SuccessScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: SuccessRouter
        
    // MARK: - Initializers
    
    init(content: SuccessContent) {
        router = DefaultSuccessRouter()
        let viewModel = DefaultSuccessViewModel(content: content, router: router)
        viewController = SuccessViewController(with: viewModel)
    }
}
