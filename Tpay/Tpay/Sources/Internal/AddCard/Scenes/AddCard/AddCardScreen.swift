//
//  Copyright © 2023 Tpay. All rights reserved.
//

import UIKit

final class AddCardScreen: Screen {
    
    // MARK: - Properties

    let viewController: UIViewController
    let router: AddCardRouter
    
    private let viewModel: AddCardViewModel
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    init(payer: Payer?, resolver: ServiceResolver) {
        let model = DefaultAddCardModel(with: payer, using: resolver)
        router = DefaultAddCardRouter()
        viewModel = DefaultAddCardViewModel(model: model, router: router)
        viewController = AddCardViewController(viewModel: viewModel)
    }
    
    // MARK: - API
    
    func set(cardData: CardNumberDetectionModels.CreditCard?) {
        guard let cardData = cardData else { return }
        viewModel.set(cardData: cardData)
    }
}
