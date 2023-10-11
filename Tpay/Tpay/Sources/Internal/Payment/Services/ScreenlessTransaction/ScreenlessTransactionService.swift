//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ScreenlessTransactionService: AnyObject {

    // MARK: - API

    func getAvailableBanks(completion: @escaping (Result<[PaymentData.Bank], Error>) -> Void)
    func getAvailableDigitalWallets(completion: @escaping (Result<[DigitalWallet], Error>) -> Void)
    func getAvailablePaymentMethods(completion: @escaping (Result<[PaymentMethod], Error>) -> Void)
    func invokePayment(with cardPaymentData: PaymentData.Card, amount: Double, payer: Payer, then: @escaping (Result<TransactionId, Error>) -> Void)
    func invokePayment(with blikPaymentData: PaymentData.Blik, amount: Double, payer: Payer, then: @escaping (Result<TransactionId, Error>) -> Void)
    func invokePayment(with bank: PaymentData.Bank, amount: Double, payer: Payer, then: @escaping (Result<TransactionUrl, Error>) -> Void)
    func invokePayment(with digitalWallet: PaymentData.DigitalWallet,
                       amount: Double,
                       payer: Payer,
                       then: @escaping (Result<TransactionId, Error>) -> Void)
}
