//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation
import os.log

final class DefaultDateToDateConverter: DateToDateConverter {
    
    // MARK: - Properties
    
    private let calendar: Calendar
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(calendar: .current)
    }
    
    init(calendar: Calendar) {
        self.calendar = calendar
    }
    
    // MARK: - API
    
    func date(byAdding value: Int, _ component: Calendar.Component, to date: Date) -> Date {
        calendar.date(byAdding: component, value: value, to: date, wrappingComponents: false).value(or: date)
    }
    
    func startOfDay(from date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    func endOfDay(from date: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        return calendar.date(byAdding: components, to: startOfDay(from: date), wrappingComponents: false).value(or: date)
    }
    
}
