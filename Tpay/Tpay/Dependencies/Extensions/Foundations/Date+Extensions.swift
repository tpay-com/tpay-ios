//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Calendar {

    func endOfDay(for date: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return self.date(byAdding: components, to: self.startOfDay(for: date))!
    }

}

extension TimeZone {

    /// Utility UTC ("Coordinated Universal Time") TimeZone instance.

    static var utc: TimeZone {
        TimeZone(abbreviation: "UTC")!
    }

}
