//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultChoosePaymentMethodModel: ChoosePaymentMethodModel {
    
    // MARK: - Events
    
    private(set) lazy var paymentMethods = _paymentMethods.asObservable()
    
    // MARK: - Properties
    
    private let paymentMethodsService: PaymentMethodsService
    private let _paymentMethods = Variable<[Domain.PaymentMethod]>([])
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        self.init(paymentMethodsService: resolver.resolve())
    }
    
    init(paymentMethodsService: PaymentMethodsService) {
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
        
        paymentMethodsService.paymentMethods.forEach { method in
            switch method {
            case .card:
                paymentMethods.append(.card, if: !paymentMethods.contains(.card))
            case .blik:
                paymentMethods.append(.blik, if: !paymentMethods.contains(.blik))
            case .pbl:
                paymentMethods.append(.pbl(.any), if: !paymentMethods.contains(.pbl(.any)))
            case .digitalWallet:
                paymentMethods.append(.digitalWallet(.any), if: !paymentMethods.contains(.digitalWallet(.any)))
            case .unknown:
                break
            }
        }
        
        _paymentMethods.value = paymentMethods
    }
    
}
