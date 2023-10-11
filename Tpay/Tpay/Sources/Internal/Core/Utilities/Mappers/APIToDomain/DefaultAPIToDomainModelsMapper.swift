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
        }
    }
    
    func makePaymentInfo(from transaction: Transaction) -> Domain.PaymentInfo {
        Domain.PaymentInfo(amount: transaction.amount, title: transaction.description)
    }
    
    func makeCard(from cardDetails: PaymentData.Card.CardDetails) -> Domain.Card {
        Domain.Card(number: cardDetails.number,
                    expiryDate: Domain.Card.ExpiryDate(month: cardDetails.expiryDate.month, year: cardDetails.expiryDate.year),
                    securityCode: cardDetails.securityCode,
                    shouldTokenize: cardDetails.shouldSave)
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
    
    func makeBank(from bank: PaymentData.Bank) -> Domain.PaymentMethod.Bank {
        Domain.PaymentMethod.Bank(id: bank.id, name: bank.name, imageUrl: bank.imageUrl)
    }
    
    // MARK: - Private
    
    private func makeCardBrand(from brand: CardToken.Brand) -> Domain.CardToken.Brand {
        switch brand {
        case .mastercard:
            return .mastercard
        case .visa:
            return .visa
        }
    }
    
    private func makeWallet(from wallet: DigitalWallet) -> Domain.PaymentMethod.DigitalWallet {
        Domain.PaymentMethod.DigitalWallet(kind: makeDigitalWalletKind(from: wallet))
    }
    
    private func makeDigitalWalletKind(from wallet: DigitalWallet) -> Domain.PaymentMethod.DigitalWallet.Kind {
        switch wallet {
        case .applePay:
            return .applePay
        case .googlePay:
            return .googlePay
        case .payPal:
            return .payPal
        }
    }
}
