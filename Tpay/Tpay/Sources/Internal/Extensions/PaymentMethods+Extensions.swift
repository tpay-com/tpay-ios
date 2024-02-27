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
    
    func allWallets() -> [Domain.PaymentMethod.DigitalWallet] {
        var wallets: [Domain.PaymentMethod.DigitalWallet] = []
        self.forEach { paymentMethod in
            guard case let .digitalWallet(wallet) = paymentMethod else { return }
            wallets.append(wallet)
        }
        return wallets
    }
    
    func allInstallmentPayments() -> [Domain.PaymentMethod.InstallmentPayment] {
        var installmentPayments: [Domain.PaymentMethod.InstallmentPayment] = []
        self.forEach { paymentMethod in
            guard case let .installmentPayments(iPayment) = paymentMethod else { return }
            installmentPayments.append(iPayment)
        }
        return installmentPayments
    }
}

extension Array where Element == Domain.PaymentMethod.Bank {
    
    func wrapped() -> [Domain.PaymentMethod] {
        map { Domain.PaymentMethod.pbl($0) }
    }
}
 
extension Array where Element == Domain.PaymentMethod.InstallmentPayment {
    
    func wrapped() -> [Domain.PaymentMethod] {
        map { Domain.PaymentMethod.installmentPayments($0) }
    }
}
