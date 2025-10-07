//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `RecursiveTransaction` struct represents a recursive transaction. It extends a specified transaction object with recursion parameters such as the frequency, quantity, and expiry date.

public struct RecursiveTransaction: Transaction, Recursive {
    
    // MARK: - Properties
    
    public let frequency: Frequency
    public let quantity: Quantity
    public let expiryDate: Date
    
    private let transaction: Transaction
    
    // MARK: - Initializers
    
    public init(wrapping transaction: Transaction, frequency: Frequency, quantity: Quantity, expiryDate: Date) {
        self.transaction = transaction
        self.frequency = frequency
        self.quantity = quantity
        self.expiryDate = expiryDate
    }
    
    // MARK: - Transaction
    
    public var amount: Double { transaction.amount }
    public var description: String { transaction.description }
    public var hiddenDescription: String? { transaction.hiddenDescription }
    public var payerContext: PayerContext? { transaction.payerContext }
    public var notification: Notification? { transaction.notification }
}
