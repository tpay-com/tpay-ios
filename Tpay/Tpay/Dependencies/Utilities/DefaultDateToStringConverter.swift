//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultDateToStringConverter: DateToStringConverter {
    
    // MARK: - Properties
    
    private let calendar: Calendar
    private let componentsFormatter = DateComponentsFormatter()
    private let dateAndTimeFormatter = AutoreleasedDateFormatter()
    private let dateFormatter = AutoreleasedDateFormatter()
    
    // MARK: - Initializers
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
        
        componentsFormatter.unitsStyle = .full
        componentsFormatter.calendar = calendar
        
        dateAndTimeFormatter.dateStyle = .medium
        dateAndTimeFormatter.timeStyle = .medium
        dateAndTimeFormatter.calendar = calendar
        dateAndTimeFormatter.locale = calendar.locale
        dateAndTimeFormatter.timeZone = calendar.timeZone
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.calendar = calendar
        dateFormatter.locale = calendar.locale
        dateFormatter.timeZone = calendar.timeZone
    }
    
    // MARK: - API
    
    func differenceString(between firstDate: Date, and secondDate: Date) -> String {
        let components: DateComponents
        switch secondDate > firstDate {
        case true: components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: firstDate, to: secondDate)
        case false: components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: secondDate, to: firstDate)
        }
        
        if let years = components.year, years > 0 {
            componentsFormatter.allowedUnits = .year
        } else if let months = components.month, months > 0 {
            componentsFormatter.allowedUnits = .month
        } else if let weeks = components.weekOfMonth, weeks > 0 {
            componentsFormatter.allowedUnits = .weekOfMonth
        } else if let days = components.day, days > 0 {
            componentsFormatter.allowedUnits = .day
        } else if let hours = components.hour, hours > 0 {
            componentsFormatter.allowedUnits = .hour
        } else if let minutes = components.minute, minutes > 0 {
            componentsFormatter.allowedUnits = .minute
        } else {
            componentsFormatter.allowedUnits = .second
        }
        
        return componentsFormatter.string(from: components).value(or: .empty)
    }
    
    func dateAndTimeString(from date: Date) -> String { dateAndTimeFormatter.string(from: date) }
    
    func dateString(from date: Date) -> String { dateFormatter.string(from: date) }
    
}
