//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

public protocol Transaction {

    // MARK: - Properties

    var amount: Double { get }
    var description: String { get }
    var hiddenDescription: String? { get }
    var payerContext: PayerContext? { get }
    var notification: Notification? { get }
}
