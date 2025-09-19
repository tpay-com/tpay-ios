//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// Converter allows map double input into string representation
protocol DoubleToStringConverter: AnyObject {
    
    /// Create formatted string from given input
    /// - Parameter number:
    func string(from number: Double) -> String
    
}
