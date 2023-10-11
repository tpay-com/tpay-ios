//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit
import UIKit

final class ApplePayScreen: Screen {
    
    private(set) lazy var viewController: UIViewController = applePayViewController
    
    private let applePayViewController: PKPaymentAuthorizationViewController
    
    // MARK: - Initializers
    
    init?(transaction: Domain.Transaction, using resolver: ServiceResolver) {
        let model = DefaultApplePayModel(using: resolver)
        guard let paymentRequest = model?.paymentRequest(for: transaction),
              let viewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else { return nil }
        applePayViewController = viewController
    }
    
    // MARK: - API
    
    func set(delegate: PKPaymentAuthorizationViewControllerDelegate) {
        applePayViewController.delegate = delegate
    }
}
