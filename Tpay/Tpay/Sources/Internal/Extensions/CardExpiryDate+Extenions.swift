//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension Domain.Card.ExpiryDate {
    
    func checkIsBackDate(comparingTo date: Date = Date(), using calendar: Calendar = .current) -> Bool {
        let currentYear = calendar.component(.year, from: date)
        let yearInCurrentCentury = currentYear % 100
        let currentMonth = calendar.component(.month, from: date)
        guard year == yearInCurrentCentury else {
            return year < yearInCurrentCentury
        }
        return month < currentMonth
    }
}
