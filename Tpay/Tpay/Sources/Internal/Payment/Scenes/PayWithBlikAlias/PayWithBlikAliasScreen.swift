//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithBlikAliasScreen: Screen {

    // MARK: - Properties

    let viewController: UIViewController
    let router: PayWithBlikAliasRouter

    // MARK: - Initializers

    init(for transaction: Domain.Transaction, with blikAlias: Domain.Blik.OneClick.Alias, using resolver: ServiceResolver) {
        router = DefaultPayWithBlikAliasRouter()
        let model = DefaultPayWithBlikAliasModel(for: transaction, with: blikAlias, using: resolver)
        let viewModel = DefaultPayWithBlikAliasViewModel(model: model, router: router)
        viewController = PayWithBlikAliasViewController(viewModel: viewModel)
    }
}
