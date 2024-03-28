//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol TransactionService: AnyObject {
    
    // MARK: - API

    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.Regular, then: @escaping OngoingTransactionResultHandler)
    func invokePayment(for transaction: Domain.Transaction, with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler)
    func invokePayment(for transaction: Domain.Transaction, with card: Domain.Card, then: @escaping OngoingTransactionResultHandler)
    func invokePayment(for transaction: Domain.Transaction, with cardToken: Domain.CardToken, then: @escaping OngoingTransactionResultHandler)
    func invokePayment(for transaction: Domain.Transaction, with pbl: Domain.PaymentMethod.Bank, then: @escaping OngoingTransactionResultHandler)
    func invokePayment(for transaction: Domain.Transaction, with applePay: Domain.ApplePayToken, then: @escaping OngoingTransactionResultHandler)
    func invokePayment(for transaction: Domain.Transaction, with installmentPayment: Domain.PaymentMethod.InstallmentPayment, then: @escaping OngoingTransactionResultHandler)
    
    func getPaymentStatus(for ongoingTransaction: Domain.OngoingTransaction, then: @escaping OngoingTransactionResultHandler)
    func continuePayment(for ongoingTransaction: Domain.OngoingTransaction, with blik: Domain.Blik.OneClick, then: @escaping OngoingTransactionResultHandler)
}
