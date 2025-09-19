//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allows map number inputs into string representation required by backend service
protocol NumberToServiceString: AnyObject {
    
    /// Create formatted string from given input
    /// - Parameter number:
    func string(from value: Int) -> String
    
    /// Create formatted string from given input
    /// - Parameter number:
    func string(from value: Decimal) -> String
    
}
