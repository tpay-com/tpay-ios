//
//  Copyright © 2023 Tpay. All rights reserved.
//

import PassKit

extension PayWithDigitalWalletViewController {
    
    final class ApplePayDelegate: NSObject {
        
        // MARK: - Properties

        private enum AuthorizationState {
            case notStarted
            case processing
            case completed(ApplePayStatus)
        }

        let viewModel: PayWithDigitalWalletViewModel

        private var sheetDidFinish = false
        private var didReportFinalStatus = false
        private var authorizationState: AuthorizationState = .notStarted

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
        guard case .notStarted = authorizationState else {
            assertionFailure("Apple Pay authorization has already started")
            completion(
                PKPaymentAuthorizationResult(
                    status: .failure,
                    errors: nil
                )
            )

            return
        }

        authorizationState = .processing

        let token = Domain.ApplePayToken(
            token: payment.token.paymentData.base64EncodedString()
        )

        viewModel.payWithApplePay(with: token) { [self] result in
            DispatchQueue.main.async { [self] in
                handleApplePayResult(result, then: completion)
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        sheetDidFinish = true
        controller.dismiss(animated: true)
        reportFinalStatusIfPossible()
    }

    // MARK: - Private
    
    private func handleApplePayResult(_ result: Result<Domain.OngoingTransaction, Error>, then: @escaping (PKPaymentAuthorizationResult) -> Void) {
        guard case .processing = authorizationState else {
            assertionFailure("Apple Pay result received in an invalid state")
            return
        }

        let applePayStatus: ApplePayStatus
        let authorizationResult: PKPaymentAuthorizationResult

        switch result {
        case .success(let transaction):
            applePayStatus = .success(transaction: transaction)
            authorizationResult = PKPaymentAuthorizationResult(
                status: .success,
                errors: nil
            )

        case .failure(let error):
            applePayStatus = .failure(error: error)
            authorizationResult = PKPaymentAuthorizationResult(
                status: .failure,
                errors: nil
            )
        }

        authorizationState = .completed(applePayStatus)
        then(authorizationResult)
        reportFinalStatusIfPossible()
    }

    private func reportFinalStatusIfPossible() {
        guard
            sheetDidFinish,
            didReportFinalStatus == false
        else {
            return
        }

        let finalStatus: ApplePayStatus

        switch authorizationState {
        case .notStarted:
            finalStatus = .notAuthorized
        case .processing:
            return
        case .completed(let status):
            finalStatus = status
        }

        didReportFinalStatus = true
        viewModel.applePayFinished(with: finalStatus)
    }
}
