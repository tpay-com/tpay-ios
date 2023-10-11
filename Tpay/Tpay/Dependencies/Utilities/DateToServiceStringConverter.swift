//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allow convert date to string expected by backend service
protocol DateToServiceStringConverter: AnyObject {
    
    /// Produce string which contains only date
    /// - Parameter date:
    func dateString(from date: Date) -> String
    
    /// Produce string which contains date with time
    /// - Parameter date: 
    func dateAndTimeString(from date: Date) -> String
    
}
