//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol TransportationToDomainModelsMapper: AnyObject {
    
    // MARK: - API
    
    func makePaymentMethod(from dto: BankGroupDTO) -> Domain.PaymentMethod
    func makeOngoingTransaction(from dto: TransactionDTO) -> Domain.OngoingTransaction
    func makeOngoingTokenization(from dto: TokenizedCardDTO) -> Domain.OngoingTokenization
}
