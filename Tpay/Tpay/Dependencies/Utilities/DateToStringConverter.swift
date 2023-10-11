//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allows convert dates into string representation
protocol DateToStringConverter: AnyObject {
    
    /// Create localized string represented biggest component between dates
    ///
    /// - Returns:
    ///     * __15 seconds__ when difference between dates is equal 15 seconds
    ///     * __3 hours__ when difference between dates exceeds 3 hours
    ///     * __1 week__ when difference between dates exceeds 1 weak
    ///
    /// - Parameters:
    ///   - firstDate:
    ///   - secondDate:
    func differenceString(between firstDate: Date, and secondDate: Date) -> String
    
    /// Create localized date string base on user settings
    /// - Parameter date:
    func dateString(from date: Date) -> String
    
    /// Create localized date with time string base on user settings
    /// - Parameter date: 
    func dateAndTimeString(from date: Date) -> String    
    
}
