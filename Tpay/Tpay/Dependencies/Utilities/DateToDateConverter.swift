//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allows conversion between dates
protocol DateToDateConverter: AnyObject {
    
    /// Create new date by adding component value to given date
    /// - Parameters:
    ///   - value: amount of component units
    ///   - component: date component which will be added to date
    ///   - date: date shifted by given arguments
    func date(byAdding value: Int, _ component: Calendar.Component, to date: Date) -> Date
    
    /// Create date which point start of day of given date
    /// - Parameter date:
    func startOfDay(from date: Date) -> Date
    
    /// Create date which point end of day of given date
    /// - Parameter date: 
    func endOfDay(from date: Date) -> Date
    
}
