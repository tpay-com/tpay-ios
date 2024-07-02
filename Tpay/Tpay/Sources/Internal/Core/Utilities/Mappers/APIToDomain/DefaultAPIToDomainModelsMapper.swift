//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultAPIToDomainModelsMapper: APIToDomainModelsMapper {
    
    // MARK: - API
    
    func makePaymentMethod(from paymentMethod: PaymentMethod) -> Domain.PaymentMethod {
        switch paymentMethod {
        case .blik:
            return .blik
        case .pbl:
            return .pbl(.any)
        case .card:
            return .card
        case let .digitalWallet(wallet):
            return .digitalWallet(makeWallet(from: wallet))
        case let .installmentPayments(installmentPayment):
            return .installmentPayments(makeInstallmentPayment(from: installmentPayment))
        case .payPo:
            return .payPo
        }
    }
    
    func makePaymentInfo(from transaction: Transaction) -> Domain.PaymentInfo {
        Domain.PaymentInfo(amount: transaction.amount, title: transaction.description)
    }
    
    func makePayer(from payer: Payer) -> Domain.Payer {
        Domain.Payer(name: payer.name,
                     email: payer.email,
                     phone: payer.phone,
                     address: Domain.Payer.Address(address: payer.address?.address,
                                                   city: payer.address?.city,
                                                   country: payer.address?.country,
                                                   postalCode: payer.address?.postalCode))
    }
    
    func makeAddress(from address: Address) -> Domain.Payer.Address {
        Domain.Payer.Address(address: address.address, city: address.city, country: address.country, postalCode: address.postalCode)
    }
    
    func makeCardToken(from cardToken: CardToken) -> Domain.CardToken {
        Domain.CardToken(token: cardToken.token, cardTail: cardToken.cardTail, brand: makeCardBrand(from: cardToken.brand))
    }
    
    func makeBlikAlias(from blikAlias: RegisteredBlikAlias) -> Domain.Blik.OneClick.Alias {
        switch blikAlias.value {
        case let .uid(value):
            return .init(value: value, type: .uId, application: nil)
        }
    }
    
    func makeBlikAlias(from blikAlias: NotRegisteredBlikAlias) -> Domain.Blik.Regular.Alias {
        switch blikAlias.value {
        case let .uid(value):
            return .init(value: value, type: .uId, label: nil)
        }
    }
    
    // MARK: - Private
    
    private func makeCardBrand(from brand: CardToken.Brand) -> Domain.CardToken.Brand {
        switch brand {
        case .mastercard:
            return .mastercard
        case .visa:
            return .visa
        case let .other(brand):
            return .other(brand)
        }
    }
    
    private func makeWallet(from wallet: DigitalWallet) -> Domain.PaymentMethod.DigitalWallet {
        Domain.PaymentMethod.DigitalWallet(kind: makeDigitalWalletKind(from: wallet))
    }
    
    private func makeDigitalWalletKind(from wallet: DigitalWallet) -> Domain.PaymentMethod.DigitalWallet.Kind {
        switch wallet {
        case .applePay:
            return .applePay
        }
    }
    
    private func makeInstallmentPayment(from installmentPayment: InstallmentPayment) -> Domain.PaymentMethod.InstallmentPayment {
        Domain.PaymentMethod.InstallmentPayment(kind: makeInstallmentPaymentKind(from: installmentPayment))
    }
    
    private func makeInstallmentPaymentKind(from installmentPayment: InstallmentPayment) -> Domain.PaymentMethod.InstallmentPayment.Kind {
        switch installmentPayment {
        case .ratyPekao:
            return .ratyPekao
        }
    }
    
    // MARK: - Headless models
    
    func makeDomainTransaction(from headlessModelsTransaction: Headless.Models.Transaction) throws -> Domain.Transaction {
        guard let payer = headlessModelsTransaction.payerContext?.payer else {
            throw Headless.Models.PaymentError.missingPayer
        }
        return Domain.Transaction(paymentInfo: .init(amount: headlessModelsTransaction.amount,
                                                     title: headlessModelsTransaction.description),
                                  payer: makePayer(from: payer))
    }
    
    func makeDomainOngoingTransaction(from headlessModelsOngoingTransaction: Headless.Models.OngoingTransaction) -> Domain.OngoingTransaction {
        Domain.OngoingTransaction(transactionId: headlessModelsOngoingTransaction.id, status: .unknown, continueUrl: nil, paymentErrors: nil)
    }
    
    func makeDomainCard(from headlessModelsCard: Headless.Models.Card) -> Domain.Card {
        let expiryDate = Domain.Card.ExpiryDate(month: headlessModelsCard.expiryDate.month,
                                                year: headlessModelsCard.expiryDate.year)
        return Domain.Card(number: headlessModelsCard.number,
                           expiryDate: expiryDate,
                           securityCode: headlessModelsCard.securityCode,
                           shouldTokenize: headlessModelsCard.shouldTokenize)
    }
    
    func makeDomainBlikRegular(from headlessModelsBlik: Headless.Models.Blik.Regular) -> Domain.Blik.Regular {
        guard let alias = headlessModelsBlik.aliasToBeRegistered,
              let mappedAlias = Helpers.makeDomainBlikAlias(from: alias) else {
            return Domain.Blik.Regular(token: headlessModelsBlik.token, alias: nil)
        }
        return Domain.Blik.Regular(token: headlessModelsBlik.token, alias: mappedAlias)
    }
    
    func makeDomainBlikOneClick(from headlessModelsBlikOneClick: Headless.Models.Blik.OneClick) throws -> Domain.Blik.OneClick {
        guard let alias = Helpers.makeDomainBlikAlias(from: headlessModelsBlikOneClick.registeredAlias) else {
            throw Headless.Models.PaymentError.missingRegisteredBlikAlias
        }
        return Domain.Blik.OneClick(alias: alias)
    }
    
    func makeDomainBlikOneClickWithApplication(from headlessModelsAmbiguousBlikAlias: Headless.Models.Blik.AmbiguousBlikAlias) throws -> Domain.Blik.OneClick {
        guard let alias = Helpers.makeDomainBlikAlias(from: headlessModelsAmbiguousBlikAlias) else {
            throw Headless.Models.PaymentError.missingRegisteredBlikAlias
        }
        return Domain.Blik.OneClick(alias: alias)
    }
    
    func makeDomainApplePayToken(from headlessModelsApplePay: Headless.Models.ApplePay) -> Domain.ApplePayToken {
        Domain.ApplePayToken(token: headlessModelsApplePay.token)
    }
}

private extension DefaultAPIToDomainModelsMapper {
    
    enum Helpers {
        
        static func makeDomainBlikAlias(from headlessModelsNotRegisteredBlikAlias: Headless.Models.NotRegisteredBlikAlias) -> Domain.Blik.Regular.Alias? {
            guard let uid = headlessModelsNotRegisteredBlikAlias.uidValue else {
                return nil
            }
            return Domain.Blik.Regular.Alias(value: uid, type: .uId)
        }
        
        static func makeDomainBlikAlias(from headlessModelsNotRegisteredBlikAlias: Headless.Models.RegisteredBlikAlias) -> Domain.Blik.OneClick.Alias? {
            guard let uid = headlessModelsNotRegisteredBlikAlias.uidValue else {
                return nil
            }
            return Domain.Blik.OneClick.Alias(value: uid, type: .uId)
        }
        
        static func makeDomainBlikAlias(from headlessModelsAmbiguousBlikAlias: Headless.Models.Blik.AmbiguousBlikAlias) -> Domain.Blik.OneClick.Alias? {
            guard let uid = headlessModelsAmbiguousBlikAlias.registeredAlias.uidValue else {
                return nil
            }
            let application = Domain.Blik.OneClick.Alias.Application(name: headlessModelsAmbiguousBlikAlias.application.key,
                                                                     key: headlessModelsAmbiguousBlikAlias.application.name)
            return Domain.Blik.OneClick.Alias(value: uid, type: .uId, application: application)
        }
    }
}

private extension BlikAlias where RegistrationStatus: AliasRegistrationStatus {
    
    var uidValue: String? {
        if case let .uid(uid) = self.value {
            return uid
        }
        return nil
    }
}
