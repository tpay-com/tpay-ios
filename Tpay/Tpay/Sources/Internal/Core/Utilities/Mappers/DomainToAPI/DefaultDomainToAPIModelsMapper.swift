//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

enum DomainToAPIModelsMapperError: Error {
    case groupIdNotSupported
}

final class DefaultDomainToAPIModelsMapper: DomainToAPIModelsMapper {
    
    // MARK: - API
    
    func makeHeadlessModelsPaymentChannel(from domainPaymentChannel: Domain.PaymentChannel) throws -> Headless.Models.PaymentChannel {
        Headless.Models.PaymentChannel(id: domainPaymentChannel.id,
                                       name: domainPaymentChannel.name,
                                       fullName: domainPaymentChannel.fullName,
                                       imageUrl: domainPaymentChannel.imageUrl,
                                       paymentKind: try Helpers.makeHeadlessModelsPaymentKind(from: domainPaymentChannel.associatedGroupId),
                                       constraints: domainPaymentChannel.constraints?.compactMap { Helpers.makeHeadlessModelsPaymentChannelConstraint(from: $0) })
    }
    
    func makeHeadlessModelsPaymentResult(from domainOngoingTransaction: Domain.OngoingTransaction) -> Headless.Models.PaymentResult {
        guard case let .ambiguousBlikAlias(alternatives: alternatives) = domainOngoingTransaction.paymentErrors?.first else {
            return Helpers.makeHeadlessModelsStandardPaymentResult(from: domainOngoingTransaction)
        }
        return Helpers.makeHeadlessModelsBlikPaymentResultWithAmbiguousAlias(from: domainOngoingTransaction,
                                                                             applications: alternatives)
    }
}

private extension DefaultDomainToAPIModelsMapper {
    
    enum Helpers {
        
        static func makeHeadlessModelsPaymentKind(from domainBankGroupId: BankGroupId) throws -> Headless.Models.PaymentKind {
            switch domainBankGroupId {
            case .card:
                return .card
            case .blik:
                return .blik
            case .applePay:
                return .applePay
            case .googlePay:
                return .googlePay
            case .ratyPekao:
                return .installmentPayments
            case .unknown:
                throw DomainToAPIModelsMapperError.groupIdNotSupported
            default:
                return .pbl
            }
        }
        
        static func makeHeadlessModelsPaymentChannelConstraint(from domainPaymentChannelConstraint: Domain.PaymentChannel.Constraint) -> Headless.Models.PaymentChannel.Constraint {
            Headless.Models.PaymentChannel.Constraint(field: domainPaymentChannelConstraint.field.rawValue,
                                                      type: domainPaymentChannelConstraint.type.rawValue,
                                                      value: domainPaymentChannelConstraint.value)
        }
        
        static func makeHeadlessModelsTransactionStatus(from domainTransactionStatus: Domain.OngoingTransaction.Status) -> Headless.Models.TransactionStatus {
            switch domainTransactionStatus {
            case .pending:
                return .pending
            case .paid:
                return .paid
            case .correct:
                return .correct
            case .refund:
                return .refund
            case .error(let error):
                return .error(error)
            case .unknown:
                return .unknown
            }
        }
        
        static func makeHeadlessModelsStandardPaymentResult(from domainOngoingTransaction: Domain.OngoingTransaction) -> Headless.Models.PaymentResult {
            let headlessOngoingTransaction = Headless.Models.OngoingTransaction(id: domainOngoingTransaction.transactionId)
            return Headless.Models.StandardPaymentResult(ongoingTransaction: headlessOngoingTransaction,
                                                         status: Helpers.makeHeadlessModelsTransactionStatus(from: domainOngoingTransaction.status),
                                                         continueUrl: domainOngoingTransaction.continueUrl)
        }
        
        static func makeHeadlessModelsBlikPaymentResultWithAmbiguousAlias(from domainOngoingTransaction: Domain.OngoingTransaction,
                                                                          applications: [Domain.Blik.OneClick.Alias.Application]) -> Headless.Models.PaymentResult {
            let headlessOngoingTransaction = Headless.Models.OngoingTransaction(id: domainOngoingTransaction.transactionId)
            let applications = applications.map { makeHeadlessModelsAmbiguousBlikAliasApplication(from: $0) }
            
            return Headless.Models.BlikPaymentResultWithAmbiguousAliases(ongoingTransaction: headlessOngoingTransaction,
                                                                         status: Helpers.makeHeadlessModelsTransactionStatus(from: domainOngoingTransaction.status),
                                                                         continueUrl: domainOngoingTransaction.continueUrl,
                                                                         applications: applications)
        }
        
        static func makeHeadlessModelsAmbiguousBlikAliasApplication(from domainOneClickBlikAliasApplication: Domain.Blik.OneClick.Alias.Application) -> Headless.Models.Blik.AmbiguousBlikAlias.Application {
            Headless.Models.Blik.AmbiguousBlikAlias.Application(name: domainOneClickBlikAliasApplication.name,
                                                                key: domainOneClickBlikAliasApplication.key)
        }
    }
}
