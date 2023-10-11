//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension [Domain.PaymentMethod] {
    
    func allBanks() -> [Domain.PaymentMethod.Bank] {
        var banks: [Domain.PaymentMethod.Bank] = []
        self.forEach { paymentMethod in
            guard case let .pbl(bank) = paymentMethod else { return }
            banks.append(bank)
        }
        return banks
    }
    
    func allBankMethods() -> [Domain.PaymentMethod] {
        var bankMethods: [Domain.PaymentMethod] = []
        self.forEach { paymentMethod in
            guard case .pbl = paymentMethod else { return }
            bankMethods.append(paymentMethod)
        }
        return bankMethods
    }
    
    func allWallets() -> [Domain.PaymentMethod.DigitalWallet] {
        var wallets: [Domain.PaymentMethod.DigitalWallet] = []
        self.forEach { paymentMethod in
            guard case let .digitalWallet(wallet) = paymentMethod else { return }
            wallets.append(wallet)
        }
        return wallets
    }
}
