//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultTransportationToDomainModelsMapper: TransportationToDomainModelsMapper {
    
    // MARK: - API
    
    func makePaymentMethod(from dto: BankGroupDTO) -> Domain.PaymentMethod {
        let groupId = dto.id
        
        switch groupId {
        case .card:
            return .card
        case .blik:
            return .blik
        case _ where BankGroupId.digitalWallets.contains(groupId):
            return .digitalWallet(makeDigitalWallet(from: dto))
        case _ where BankGroupId.bankIds.contains(groupId):
            return .pbl(makeBank(from: dto))
        default: return .unknown
        }
    }
    
    func makeOngoingTransaction(from dto: TransactionDTO) -> Domain.OngoingTransaction {
        Domain.OngoingTransaction(transactionId: dto.transactionId,
                                  status: makeTransactionStatus(from: dto.status),
                                  continueUrl: URL(string: dto.transactionPaymentUrl.value(or: .empty)),
                                  paymentErrors: makePaymentErrorsIfApplies(from: dto.payments))
    }
    
    func makeOngoingTokenization(from dto: TokenizedCardDTO) -> Domain.OngoingTokenization {
        Domain.OngoingTokenization(result: makeResult(from: dto.result), requestId: dto.requestId, tokenizationId: dto.id, continueUrl: URL(string: dto.url))
    }
    
    // MARK: - Private
    
    private func makeBank(from dto: BankGroupDTO) -> Domain.PaymentMethod.Bank {
        Domain.PaymentMethod.Bank(id: dto.id.rawValue, name: dto.name, imageUrl: URL(string: dto.img))
    }
    
    private func makeTransactionStatus(from dto: TransactionDTO.TransactionStatus) -> Domain.OngoingTransaction.Status {
        switch dto {
        case .pending:
            return .pending
        case .paid:
            return .paid
        case .correct:
            return .correct
        case .refund:
            return .refund
        case .error:
            return .error(PaymentError.unknown)
        }
    }
    
    private func makePaymentErrorsIfApplies(from dto: TransactionDTO.Payments?) -> [Domain.OngoingTransaction.PaymentError]? {
        guard let dto = dto else {
            return nil
        }
        
        var accumulatedErrors = [Domain.OngoingTransaction.PaymentError]()
        if let status = dto.status, status == .declined {
            accumulatedErrors.append(.declined)
        }
        if let attempts = dto.attempts {
            accumulatedErrors.append(contentsOf: attempts.compactMap(\.paymentErrorCode).map { Domain.OngoingTransaction.PaymentError.attemptError(code: $0.rawValue) })
        }
        if let alternatives = dto.alternatives {
            accumulatedErrors.append(Domain.OngoingTransaction.PaymentError.ambiguousBlikAlias(alternatives: alternatives.map { .init(name: $0.applicationName, key: $0.applicationCode) }))
        }
        if let otherErrors = dto.errors {
            accumulatedErrors.append(contentsOf: otherErrors.compactMap(\.errorMessage).map { Domain.OngoingTransaction.PaymentError.invalidData(description: $0) })
        }
        return accumulatedErrors.isEmpty ? nil : accumulatedErrors
    }
    
    private func makeResult(from dto: ResponseDTO.Result) -> Domain.OngoingTokenization.Result {
        switch dto {
        case .success:
            return .success
        case .actionRequired:
            return .actionRequired
        case .pending:
            return .pending
        case .failed:
            return .failed
        }
    }
    
    private func makeDigitalWallet(from dto: BankGroupDTO) -> Domain.PaymentMethod.DigitalWallet {
        Domain.PaymentMethod.DigitalWallet(id: dto.id.rawValue,
                                           kind: makeDigitalWalletKind(from: dto.id),
                                           name: dto.name,
                                           imageUrl: URL(string: dto.img))
    }
    
    private func makeDigitalWalletKind(from dto: BankGroupId) -> Domain.PaymentMethod.DigitalWallet.Kind {
        switch dto {
        case .applePay:
            return .applePay
        case .googlePay:
            return .googlePay
        case .payPal:
            return .payPal
        default:
            return .unknown
        }
    }
}

private extension BankGroupId {
    
    // MARK: - Properties
    
    static var bankIds: [BankGroupId] = [.alior, .pekao, .pko, .inteligo, .mBank, .ing, .millennium, .santander, .citibank, .creditAgricole, .velo, .pocztowy, .bankiSpoldzielcze, .bnpParibas, .neo, .nest, .plus]
    static var digitalWallets: [BankGroupId] = [.applePay, .googlePay, .payPal]
}
