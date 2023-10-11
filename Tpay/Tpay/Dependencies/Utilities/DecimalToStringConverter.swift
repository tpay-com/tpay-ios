//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allows map decimal input into string representation
protocol DecimalToStringConverter: AnyObject {
    
    /// Create formatted string from given input
    /// - Parameter number: 
    func string(from number: Decimal) -> String
    
}
