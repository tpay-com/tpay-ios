//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol APIToDomainModelsMapper: AnyObject {
    
    // MARK: - API
    
    func makePaymentMethod(from paymentMethod: PaymentMethod) -> Domain.PaymentMethod
    func makePaymentInfo(from transaction: Transaction) -> Domain.PaymentInfo
    func makePayer(from payer: Payer) -> Domain.Payer
    func makeAddress(from address: Address) -> Domain.Payer.Address
    
    func makeCard(from cardDetails: PaymentData.Card.CardDetails) -> Domain.Card
    func makeCardToken(from cardToken: CardToken) -> Domain.CardToken
    
    func makeBlikAlias(from blikAlias: RegisteredBlikAlias) -> Domain.Blik.OneClick.Alias
    func makeBlikAlias(from blikAlias: NotRegisteredBlikAlias) -> Domain.Blik.Regular.Alias
    
    func makeBank(from bank: PaymentData.Bank) -> Domain.PaymentMethod.Bank
}
