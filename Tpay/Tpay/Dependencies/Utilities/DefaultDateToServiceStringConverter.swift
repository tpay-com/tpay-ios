//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultDateToServiceStringConverter: DateToServiceStringConverter {
    
    // MARK: - Properties
    
    private let dateAndTimeFormatter = ISO8601DateFormatter()
    private let dateFormatter = AutoreleasedDateFormatter()
    
    // MARK: - Initializers
    
    init(timeZone: TimeZone? = nil) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateAndTimeFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]
        
        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone
            dateAndTimeFormatter.timeZone = timeZone
        }
    }
    
    // MARK: - API
    
    func dateString(from date: Date) -> String { dateFormatter.string(from: date) }
    
    func dateAndTimeString(from date: Date) -> String { dateAndTimeFormatter.string(from: date) }
    
}
