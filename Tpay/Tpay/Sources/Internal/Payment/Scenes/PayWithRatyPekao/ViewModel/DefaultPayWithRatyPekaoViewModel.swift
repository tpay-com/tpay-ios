//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

final class DefaultPayWithRatyPekaoViewModel: PayWithRatyPekaoViewModel {
    
    // MARK: - Events
    
    let isProcessing = Observable<Bool>()
    let isValid = Observable<Bool>()

    // MARK: - Properties
    
    var paymentVariants: [Domain.PaymentMethod.InstallmentPayment] { model.installmentPayments }
    var transaction: Domain.Transaction { model.transaction }

    private let model: PayWithRatyPekaoModel
    private let router: PayWithRatyPekaoRouter
    
    private var selectedPaymentVariant: Domain.PaymentMethod.InstallmentPayment?
    
    // MARK: - Initializers

    init(model: PayWithRatyPekaoModel, router: PayWithRatyPekaoRouter) {
        self.model = model
        self.router = router
    }
    
    // MARK: - API
    
    func select(paymentVariant: Domain.PaymentMethod.InstallmentPayment) {
        selectedPaymentVariant = paymentVariant
        isValid.on(.next(true))
    }
    
    func invokePayment() {
        guard let selectedPaymentVariant = selectedPaymentVariant else {
            isValid.on(.next(false))
            return
        }
        
        startProcessing()
        model.invokePayment(with: selectedPaymentVariant) { [weak self] result in
            self?.stopProcessing()
            guard let self else { return }
            switch result {
            case .success(let ongoingTransaction):
                self.router.invokeOnTransactionCreated(with: ongoingTransaction)
            case .failure(let error):
                self.router.invokeOnError(with: error)
            }
        }
    }
    
    // MARK: - Private

    private func startProcessing() {
        isProcessing.on(.next(true))
    }
    
    private func stopProcessing() {
        isProcessing.on(.next(false))
    }
}
