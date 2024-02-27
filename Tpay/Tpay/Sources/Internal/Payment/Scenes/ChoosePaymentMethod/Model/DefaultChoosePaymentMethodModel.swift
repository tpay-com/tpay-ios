//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultChoosePaymentMethodModel: ChoosePaymentMethodModel {
    
    // MARK: - Events
    
    private(set) lazy var paymentMethods = _paymentMethods.asObservable()
    
    // MARK: - Properties
    
    private let transaction: Domain.Transaction
    private let paymentMethodsService: PaymentMethodsService
    private let _paymentMethods = Variable<[Domain.PaymentMethod]>([])
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction, using resolver: ServiceResolver) {
        self.init(for: transaction, paymentMethodsService: resolver.resolve())
    }
    
    init(for transaction: Domain.Transaction, paymentMethodsService: PaymentMethodsService) {
        self.transaction = transaction
        self.paymentMethodsService = paymentMethodsService
        
        setPaymentMethods()
    }
    
    // MARK: - API
    
    func getPaymentMethods() -> [Domain.PaymentMethod] {
        _paymentMethods.currentValue
    }
    
    // MARK: - Private
    
    private func setPaymentMethods() {
        var paymentMethods: [Domain.PaymentMethod] = []
        let availablePaymentMethodsForSpecifiedTransaction = paymentMethodsService.resolveAvailablePaymentMethods(for: transaction)
        
        availablePaymentMethodsForSpecifiedTransaction.forEach { method in
            switch method {
            case .card:
                paymentMethods.append(.card, if: !paymentMethods.contains(.card))
            case .blik:
                paymentMethods.append(.blik, if: !paymentMethods.contains(.blik))
            case .pbl:
                paymentMethods.append(.pbl(.any), if: !paymentMethods.contains(.pbl(.any)))
            case .digitalWallet:
                paymentMethods.append(.digitalWallet(.any), if: !paymentMethods.contains(.digitalWallet(.any)))
            case .installmentPayments:
                paymentMethods.append(.installmentPayments(.any), if: !paymentMethods.contains(.installmentPayments(.any)))
            case .unknown:
                break
            }
        }
        
        _paymentMethods.value = paymentMethods
    }
}
