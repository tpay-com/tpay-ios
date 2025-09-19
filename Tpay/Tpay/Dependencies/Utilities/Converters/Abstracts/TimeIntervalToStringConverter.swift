//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allows map TimeInterval input into string representation
protocol TimeIntervalToStringConverter: AnyObject {
    
    /// Create string formatted into duration from given value
    /// - Parameter timeInterval: 
    func duration(from timeInterval: TimeInterval) -> String
    
}
