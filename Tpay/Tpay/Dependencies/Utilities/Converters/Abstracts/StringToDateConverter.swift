//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allows map string input into date
protocol StringToDateConverter: AnyObject {
    
    /// Create date from given string or nil if input is invalid
    /// - Parameter string: 
    func date(from string: String) -> Date?
    
}
