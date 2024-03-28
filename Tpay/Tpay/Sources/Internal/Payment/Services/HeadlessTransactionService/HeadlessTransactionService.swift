//
//  Copyright © 2024 Tpay. All rights reserved.
//

protocol HeadlessTransactionService: AnyObject {
    
    // MARK: - API
    
    func getAvailablePaymentChannels(completion: @escaping (Result<[Headless.Models.PaymentChannel], Error>) -> Void)
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with card: Headless.Models.Card,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with cardToken: Headless.Models.CardToken,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with blik: Headless.Models.Blik.Regular,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with blik: Headless.Models.Blik.OneClick,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with bank: Headless.Models.Bank,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with applePay: Headless.Models.ApplePay,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
    
    func invokePayment(for transaction: Headless.Models.Transaction,
                       using paymentChannel: Headless.Models.PaymentChannel,
                       with installment: Headless.Models.InstallmentPayment,
                       completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
    
    func getPaymentStatus(for ongoingTransaction: Headless.Models.OngoingTransaction,
                          completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void)
    
    func continuePayment(for ongoingTransaction: Headless.Models.OngoingTransaction,
                         with blikAlias: Headless.Models.Blik.AmbiguousBlikAlias,
                         completion: @escaping (Result<Headless.Models.PaymentResult, Error>) -> Void) throws
}
