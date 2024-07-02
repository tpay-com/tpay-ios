//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

/// The `Headless` API provides functionality for performing headless (without using Payment Sheet) transactions and handling payment-related operations. Developers can use this API to create and manage transactions independently, catering to specific use cases or custom user interfaces.

public enum Headless {
    
    private static let headlessTransactionService: HeadlessTransactionService = DefaultHeadlessTransactionService(using: ModuleContainer.instance.resolver)
    
    // MARK: - API
    
    /// Retrieves the available payment channels supported by the Tpay module.
    ///
    /// - Parameters:
    ///   - completion: A closure to be called upon completion with the result containing available payment channels.
    /// - Important: Ensure to call this method initially before initiating any payment invocation.
    
    public static func getAvailablePaymentChannels(completion: @escaping (Result<[Models.PaymentChannel], Error>) -> Void) {
        headlessTransactionService.getAvailablePaymentChannels(completion: completion)
    }
    
    /// Initiates a payment for a given transaction, payment channel, and card information.
    ///
    /// - Parameters:
    ///   - transaction: The transaction for which the payment is initiated.
    ///   - paymentChannel: The payment channel through which the payment is processed.
    ///   - card: The card information for card payments.
    ///   - completion: A closure to be called upon completion with the result containing payment status.
    /// - Throws: An error of type `Models.PaymentError` if the payment kind is inappropriate or missing required data.
    
    public static func invokePayment(for transaction: Models.Transaction,
                                     using paymentChannel: Models.PaymentChannel,
                                     with card: Models.Card,
                                     completion: @escaping (Result<PaymentResult, Error>) -> Void) throws {
        guard paymentChannel.paymentKind == .card else { throw Models.PaymentError.inappropriatePaymentKind }
        try headlessTransactionService.invokePayment(for: transaction, using: paymentChannel, with: card, completion: completion)
    }
    
    /// Initiates a payment for a given transaction, payment channel, and card token information.
    ///
    /// - Parameters:
    ///   - transaction: The transaction for which the payment is initiated.
    ///   - paymentChannel: The payment channel through which the payment is processed.
    ///   - cardToken: The card token information for card token payments.
    ///   - completion: A closure to be called upon completion with the result containing payment status.
    /// - Throws: An error of type `Models.PaymentError` if the payment kind is inappropriate or missing required data.
        
    public static func invokePayment(for transaction: Headless.Models.Transaction,
                                     using paymentChannel: Models.PaymentChannel,
                                     with cardToken: Models.CardToken,
                                     completion: @escaping (Result<Models.PaymentResult, Error>) -> Void) throws {
        guard paymentChannel.paymentKind == .card else { throw Models.PaymentError.inappropriatePaymentKind }
        try headlessTransactionService.invokePayment(for: transaction, using: paymentChannel, with: cardToken, completion: completion)
    }
    
    /// Initiates a BLIK payment for a given transaction, payment channel, and BLIK regular information.
    ///
    /// - Parameters:
    ///   - transaction: The transaction for which the payment is initiated.
    ///   - paymentChannel: The payment channel through which the payment is processed.
    ///   - blik: The BLIK regular information for BLIK payments.
    ///   - completion: A closure to be called upon completion with the result containing payment status.
    /// - Throws: An error of type `Models.PaymentError` if the payment kind is inappropriate or missing required data.
        
    public static func invokePayment(for transaction: Models.Transaction,
                                     using paymentChannel: Models.PaymentChannel,
                                     with blik: Models.Blik.Regular,
                                     completion: @escaping (Result<Models.PaymentResult, Error>) -> Void) throws {
        guard paymentChannel.paymentKind == .blik else { throw Models.PaymentError.inappropriatePaymentKind }
        try headlessTransactionService.invokePayment(for: transaction, using: paymentChannel, with: blik, completion: completion)
    }
    
    /// Initiates a BLIK payment for a given transaction, payment channel, and BLIK one-click information.
    ///
    /// - Parameters:
    ///   - transaction: The transaction for which the payment is initiated.
    ///   - paymentChannel: The payment channel through which the payment is processed.
    ///   - blik: The BLIK one-click information for BLIK payments.
    ///   - completion: A closure to be called upon completion with the result containing payment status.
    /// - Throws: An error of type `Models.PaymentError` if the payment kind is inappropriate or missing required data.
    
    public static func invokePayment(for transaction: Models.Transaction,
                                     using paymentChannel: Models.PaymentChannel,
                                     with blik: Models.Blik.OneClick,
                                     completion: @escaping (Result<Models.PaymentResult, Error>) -> Void) throws {
        guard paymentChannel.paymentKind == .blik else { throw Models.PaymentError.inappropriatePaymentKind }
        try headlessTransactionService.invokePayment(for: transaction, using: paymentChannel, with: blik, completion: completion)
    }
    
    /// Initiates a payment for a given transaction and payment channel. This method is dedicated for `pbl`, `instalmentPayments` and `payPo` channels.
    ///
    /// - Parameters:
    ///   - transaction: The transaction for which the payment is initiated.
    ///   - paymentChannel: The payment channel through which the payment is processed.
    ///   - completion: A closure to be called upon completion with the result containing payment status.
    /// - Throws: An error of type `Models.PaymentError` if the payment kind is inappropriate or missing required data.
    
    public static func invokePayment(for transaction: Models.Transaction,
                                     using paymentChannel: Models.PaymentChannel,
                                     completion: @escaping (Result<Models.PaymentResult, Error>) -> Void) throws {
        switch paymentChannel.paymentKind {
        case .pbl:
            try headlessTransactionService.invokePayment(for: transaction, using: paymentChannel, with: Models.Bank(), completion: completion)
        case .installmentPayments:
            try headlessTransactionService.invokePayment(for: transaction, using: paymentChannel, with: Models.InstallmentPayment(), completion: completion)
        case .payPo:
            try headlessTransactionService.invokePayPoPayment(for: transaction, using: paymentChannel, completion: completion)
        default:
            throw Models.PaymentError.inappropriatePaymentKind
        }
    }
    
    /// Initiates an Apple Pay payment for a given transaction, payment channel, and Apple Pay information.
    ///
    /// - Parameters:
    ///   - transaction: The transaction for which the payment is initiated.
    ///   - paymentChannel: The payment channel through which the payment is processed.
    ///   - applePay: The Apple Pay information for Apple Pay payments.
    ///   - completion: A closure to be called upon completion with the result containing payment status.
    /// - Throws: An error of type `Models.PaymentError` if the payment kind is inappropriate or missing required data.
    
    public static func invokePayment(for transaction: Models.Transaction,
                                     using paymentChannel: Models.PaymentChannel,
                                     with applePay: Models.ApplePay,
                                     completion: @escaping (Result<Models.PaymentResult, Error>) -> Void) throws {
        guard paymentChannel.paymentKind == .applePay else { throw Models.PaymentError.inappropriatePaymentKind }
        try headlessTransactionService.invokePayment(for: transaction, using: paymentChannel, with: applePay, completion: completion)
    }
    
    /// Retrieves the payment status for an ongoing transaction.
    ///
    /// - Parameters:
    ///   - ongoingTransaction: The ongoing transaction for which the payment status is requested.
    ///   - completion: A closure to be called upon completion with the result containing the payment status.
    
    public static func getPaymentStatus(for ongoingTransaction: Models.OngoingTransaction,
                                        completion: @escaping (Result<Models.PaymentResult, Error>) -> Void) {
        headlessTransactionService.getPaymentStatus(for: ongoingTransaction, completion: completion)
    }
    
    /// Continues a BLIK payment for an ongoing transaction with an ambiguous BLIK alias.
    ///
    /// - Parameters:
    ///   - ongoingTransaction: The ongoing transaction for which the payment continues.
    ///   - blikAlias: The ambiguous BLIK alias to continue the payment with.
    ///   - completion: A closure to be called upon completion with the result containing the payment status.
    /// - Throws: An error if continuing the payment is not possible or encounters an issue.
    
    public static func continuePayment(for ongoingTransaction: Models.OngoingTransaction,
                                       with blikAlias: Models.Blik.AmbiguousBlikAlias,
                                       completion: @escaping (Result<Models.PaymentResult, Error>) -> Void) throws {
        try headlessTransactionService.continuePayment(for: ongoingTransaction, with: blikAlias, completion: completion)
    }
}

// MARK: - Models

/// A protocol representing the result of a payment operation.

public protocol PaymentResult {
    
    /// The ongoing transaction associated with the payment result.

    var ongoingTransaction: Headless.Models.OngoingTransaction { get }
    
    /// The current status of the transaction.

    var status: Headless.Models.TransactionStatus { get }
    
    /// The URL to continue the payment, if applicable.

    var continueUrl: URL? { get }
}

extension Headless {
    
    public enum Models {
        
        public typealias CardToken = Tpay.CardToken
        public typealias PaymentResult = Tpay.PaymentResult
        public typealias Transaction = Tpay.Transaction
        public typealias Payer = Tpay.Payer
        public typealias RegisteredBlikAlias = Tpay.RegisteredBlikAlias
        public typealias NotRegisteredBlikAlias = Tpay.NotRegisteredBlikAlias
        
        struct Bank { }
        struct InstallmentPayment { }
        
        /// The possible kinds of payments supported by the module.
        
        public enum PaymentKind {
            case card
            case blik
            case pbl
            case applePay
            case googlePay
            case installmentPayments
            case payPo
        }
        
        /// Possible errors that may occur during headless payment operations.
        
        public enum PaymentError: Error {
            case inappropriatePaymentKind
            case missingPayer
            case missingOngoingTransaction
            case missingRegisteredBlikAlias
        }
        
        /// Possible transaction statuses during a headless payment operation.
        
        public enum TransactionStatus {
            case pending
            case paid
            case correct
            case refund
            case error(Error)
            case unknown
        }
        
        /// Represents an ongoing transaction with an identifier.
        
        public struct OngoingTransaction {
            public let id: String
        }
        
        /// Represents a payment channel through which a payment can be processed.
        
        public struct PaymentChannel {
            public let id: String
            public let name: String
            public let fullName: String
            public let imageUrl: URL?
            public let paymentKind: Headless.Models.PaymentKind
            public let constraints: [Constraint]?
            
            public struct Constraint {
                public let field: String
                public let type: String
                public let value: String
            }
        }
        
        /// Represents the standard result of a headless payment operation.
        
        public struct StandardPaymentResult: PaymentResult {
            public let ongoingTransaction: Headless.Models.OngoingTransaction
            public var status: Headless.Models.TransactionStatus
            public let continueUrl: URL?
        }
        
        /// Represents the result of a BLIK payment headless operation with ambiguous BLIK aliases.
        
        public struct BlikPaymentResultWithAmbiguousAliases: PaymentResult {
            public let ongoingTransaction: Headless.Models.OngoingTransaction
            public var status: Headless.Models.TransactionStatus
            public let continueUrl: URL?
            public let applications: [Blik.AmbiguousBlikAlias.Application]
        }
        
        /// Represents a payment card.
        
        public struct Card {
            
            let number: String
            let expiryDate: ExpiryDate
            let securityCode: String
            let shouldTokenize: Bool
            
            public init(number: String, expiryDate: ExpiryDate, securityCode: String, shouldTokenize: Bool) {
                self.number = number
                self.expiryDate = expiryDate
                self.securityCode = securityCode
                self.shouldTokenize = shouldTokenize
            }
            
            public struct ExpiryDate {
                
                let month: Int
                let year: Int
                
                public init(month: Int, year: Int) {
                    self.month = month
                    self.year = year
                }
            }
        }
        
        public enum Blik {
            
            /// Represents a regular BLIK payment (via BLIK code).
            
            public struct Regular {
                
                let token: String
                let aliasToBeRegistered: NotRegisteredBlikAlias?
                
                public init(token: String, aliasToBeRegistered: NotRegisteredBlikAlias?) {
                    self.token = token
                    self.aliasToBeRegistered = aliasToBeRegistered
                }
            }
            
            /// Represents a one-click BLIK payment (via BLIK alias).
            
            public struct OneClick {
                
                let registeredAlias: RegisteredBlikAlias
                
                public init(registeredAlias: RegisteredBlikAlias) {
                    self.registeredAlias = registeredAlias
                }
            }
            
            /// Represents an ambiguous BLIK alias.
            
            public struct AmbiguousBlikAlias {
                
                let registeredAlias: RegisteredBlikAlias
                let application: Application
                
                public init(registeredAlias: RegisteredBlikAlias, application: Application) {
                    self.registeredAlias = registeredAlias
                    self.application = application
                }
                
                public struct Application {
                    public let name: String
                    public let key: String
                }
            }
        }
        
        /// Represents Apple Pay information for a payment.
 
        public struct ApplePay {
            
            let token: String
            
            public init(token: String) {
                self.token = token
            }
        }
    }
}
