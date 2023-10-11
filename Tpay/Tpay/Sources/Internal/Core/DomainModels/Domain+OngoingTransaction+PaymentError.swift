//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension Domain.OngoingTransaction {
    
    enum PaymentError: LocalizedError {
        
        // MARK: - Cases
        
        case ambiguousBlikAlias(alternatives: [Domain.Blik.OneClick.Alias.Application])
        case attemptError(code: String)
        case invalidData(description: String)
        
        // MARK: - LocalizedError
        
        var errorDescription: String? {
            switch self {
            case .ambiguousBlikAlias:
                return "Ambiguous BLIK alias, should be handled by providing a specific application key."
            case .attemptError(let code):
                return Self.localizedDescriptionForAttemptError(code: code)
            case .invalidData(let description):
                return description
            }
        }
    }
}

extension Domain.OngoingTransaction.PaymentError {
    
    var priority: Int {
        switch self {
        case .ambiguousBlikAlias:
            return 0
        case .attemptError:
            return 1
        case .invalidData:
            return 2
        }
    }
}

extension Domain.OngoingTransaction.PaymentError: Comparable {

    static func < (lhs: Domain.OngoingTransaction.PaymentError, rhs: Domain.OngoingTransaction.PaymentError) -> Bool {
        lhs.priority < rhs.priority
    }
    
    static func == (lhs: Domain.OngoingTransaction.PaymentError, rhs: Domain.OngoingTransaction.PaymentError) -> Bool {
        lhs.priority == rhs.priority
    }
}

private extension Domain.OngoingTransaction.PaymentError {
    
    static func localizedDescriptionForAttemptError(code: String) -> String {
        switch TransactionDTO.Payments.Attempt.AttemptError(rawValue: code) {
        case .blikUnknownError:
            return Strings.transactionAttemptErrorBlikUnknown
        case .blikPaymentDeclined:
            return Strings.transactionAttemptErrorBlikDeclined
        case .blikGeneralError:
            return Strings.transactionAttemptErrorBlikGeneral
        case .blikInsufficentFunds:
            return Strings.transactionAttemptErrorBlikInsufficientFunds
        case .blikTimeout:
            return Strings.transactionAttemptErrorBlikTimeout
        default:
            return .empty
        }
    }
}
