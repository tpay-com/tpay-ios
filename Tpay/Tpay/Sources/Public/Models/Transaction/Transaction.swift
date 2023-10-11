//
//  Copyright © 2022 Tpay. All rights reserved.
//

public protocol Transaction {
    
    // MARK: - Properties
    
    var amount: Double { get }
    var description: String { get }
    var payerContext: PayerContext? { get }
}
