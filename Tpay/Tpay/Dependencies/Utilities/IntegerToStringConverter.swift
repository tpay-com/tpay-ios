//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// Converter allows map integer input into string representation
protocol IntegerToStringConverter: AnyObject {
    
    /// Create formatted string from given input
    /// - Parameter number:
    func string(from integer: Int) -> String
    
}
