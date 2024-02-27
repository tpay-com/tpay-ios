//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PaymentDataService: AnyObject {

    // MARK: - API
    
    func fetchChannels(then: @escaping Completion)
    func fetchBankGroups(then: @escaping Completion)
    func getAvailableBanks(then: @escaping (Result<[Domain.PaymentMethod.Bank], Error>) -> Void)
    func getAvailableDigitalWallets(then: @escaping (Result<[Domain.PaymentMethod.DigitalWallet], Error>) -> Void)
    func getAvailablePaymentMethods(then: @escaping (Result<[Domain.PaymentMethod], Error>) -> Void)
}
