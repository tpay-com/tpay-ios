//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class PayWithCardScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: PayWithCardRouter
    
    private let viewModel: PayWithCardViewModel
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(for transaction: Domain.Transaction, using resolver: ServiceResolver, isNavigationToOneClickEnabled: Bool, transactionLock: SingleTransactionLock) {
        let model = DefaultPayWithCardModel(using: resolver, transactionLock: transactionLock)
        router = DefaultPayWithCardRouter()
        viewModel = DefaultPayWithCardViewModel(for: transaction, model: model, router: router, isNavigationToOneClickEnabled: isNavigationToOneClickEnabled)
        viewController = PayWithCardViewController(with: viewModel)
    }
    
    // MARK: - API
    
    func set(cardData: CardNumberDetectionModels.CreditCard?) {
        guard let cardData = cardData else { return }
        viewModel.set(cardData: cardData)
    }
}
