//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `SingleTransaction` struct represents a single transaction with associated properties such as the transaction amount, description, and payer context.
///
/// - Note: The payerContext property is optional and can be left as nil if not applicable.

public struct SingleTransaction: Transaction {
    
    // MARK: - Properties
    
    public let amount: Double
    public let description: String
    public let payerContext: PayerContext?
    
    // MARK: - Initializers
    
    public init(amount: Double, description: String, payerContext: PayerContext? = nil) {
        self.amount = amount
        self.description = description
        self.payerContext = payerContext
    }
}
