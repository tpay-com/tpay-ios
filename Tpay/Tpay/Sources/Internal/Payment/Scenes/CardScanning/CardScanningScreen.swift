//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
final class CardScanningScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: CardScanningRouter
    
    // MARK: - Initializers
    
    init() {
        router = DefaultCardScanningRouter()
        let viewModel = DefaultCardScanningViewModel(router: router)
        viewController = CardScanningViewController(viewModel: viewModel)
    }
}
