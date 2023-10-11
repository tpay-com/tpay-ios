//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit

extension PayWithDigitalWalletViewController {
    
    final class ApplePayDelegate: NSObject {
        
        // MARK: - Properties
        
        let viewModel: PayWithDigitalWalletViewModel
        
        private var status: ApplePayStatus = .notAuthorized
        
        // MARK: - Initializers
        
        init(viewModel: PayWithDigitalWalletViewModel) {
            self.viewModel = viewModel
        }
    }
}

extension PayWithDigitalWalletViewController.ApplePayDelegate: PKPaymentAuthorizationViewControllerDelegate {
    
    // MARK: - Delegate
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        viewModel.payWithApplePay(with: Domain.ApplePayToken(token: payment.token.paymentData.base64EncodedString())) { [weak self] result in
            self?.handleApplePayResult(result, then: completion)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        viewModel.applePayFinished(with: status)
        controller.dismiss(animated: true)
    }
    
    // MARK: - Private
    
    private func handleApplePayResult(_ result: Result<Domain.OngoingTransaction, Error>, then: @escaping (PKPaymentAuthorizationResult) -> Void) {
        switch result {
        case .success(let transaction):
            status = .success(transaction: transaction)
            then(.init(status: .success, errors: nil))
        case .failure(let error):
            status = .failure(error: error)
            then(.init(status: .failure, errors: [error]))
        }
    }
}
