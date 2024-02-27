//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

extension PaymentMethodsService {
    
    func channelId(for associatedBankGroupId: BankGroupId) throws -> Domain.ChannelId {
        let paymentChannel = try paymentChannels
            .first { $0.associatedGroupId == associatedBankGroupId }
            .value(orThrow: PaymentMethodsServiceError.noPaymentChannelAssociatedWithBankGroupId)
        return paymentChannel.id
    }
    
    func resolveAvailablePaymentMethods(for transaction: Domain.Transaction) -> [Domain.PaymentMethod] {
        let channelForAvailablePaymentMethodMap = paymentMethods
            .reduce(into: [:]) { result, item in result[item] = try? channel(for: item) }
        return channelForAvailablePaymentMethodMap.compactMap { $0.value.testAvailabilityAgainst(paymentInfo: transaction.paymentInfo) ? $0.key : nil }
    }
}

private enum PaymentMethodsServiceError: Error {
    case noPaymentChannelAssociatedWithBankGroupId
}

private extension PaymentMethodsService {
    
    func channel(for paymentMethod: Domain.PaymentMethod) throws -> Domain.PaymentChannel {
        let channelId = try channelId(for: paymentMethod)
        return try paymentChannels.first { $0.id == channelId }.value(orThrow: PaymentMethodsServiceError.noPaymentChannelAssociatedWithBankGroupId)
    }
    
    func channelId(for paymentMethod: Domain.PaymentMethod) throws -> Domain.ChannelId {
        switch paymentMethod {
        case .blik:
            return try channelId(for: BankGroupId.blik)
        case .pbl(let bank):
            return bank.id
        case .card:
            return try channelId(for: BankGroupId.card)
        case .digitalWallet(let digitalWallet):
            return digitalWallet.id
        case .installmentPayments(let installmentPayment):
            return installmentPayment.id
        case .unknown:
            throw PaymentMethodsServiceError.noPaymentChannelAssociatedWithBankGroupId
        }
    }
}
