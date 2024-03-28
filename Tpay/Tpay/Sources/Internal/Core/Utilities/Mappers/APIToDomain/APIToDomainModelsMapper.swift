//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol APIToDomainModelsMapper: AnyObject {
    
    // MARK: - API
    
    func makePaymentMethod(from paymentMethod: PaymentMethod) -> Domain.PaymentMethod
    func makePaymentInfo(from transaction: Transaction) -> Domain.PaymentInfo
    func makePayer(from payer: Payer) -> Domain.Payer
    func makeAddress(from address: Address) -> Domain.Payer.Address
    func makeCardToken(from cardToken: CardToken) -> Domain.CardToken
    func makeBlikAlias(from blikAlias: RegisteredBlikAlias) -> Domain.Blik.OneClick.Alias
    func makeBlikAlias(from blikAlias: NotRegisteredBlikAlias) -> Domain.Blik.Regular.Alias
    
    // MARK: - Headless models
    
    func makeDomainTransaction(from headlessModelsTransaction: Headless.Models.Transaction) throws -> Domain.Transaction
    func makeDomainOngoingTransaction(from headlessModelsOngoingTransaction: Headless.Models.OngoingTransaction) -> Domain.OngoingTransaction
    func makeDomainCard(from headlessModelsCard: Headless.Models.Card) -> Domain.Card
    func makeDomainBlikRegular(from headlessModelsBlikRegular: Headless.Models.Blik.Regular) -> Domain.Blik.Regular
    func makeDomainBlikOneClick(from headlessModelsBlikOneClick: Headless.Models.Blik.OneClick) throws -> Domain.Blik.OneClick
    func makeDomainBlikOneClickWithApplication(from headlessModelsAmbiguousBlikAlias: Headless.Models.Blik.AmbiguousBlikAlias) throws -> Domain.Blik.OneClick
    func makeDomainApplePayToken(from headlessModelsApplePay: Headless.Models.ApplePay) -> Domain.ApplePayToken
}
