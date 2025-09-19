//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultStringToDateConverter: StringToDateConverter {
    
    // MARK: - Properties
    
    private let isoFormatter = ISO8601DateFormatter()
    private let isoFormatterWithoutSeconds = ISO8601DateFormatter()
    private let shortDateFormatter = AutoreleasedDateFormatter()
    
    // MARK: - Initializers
    
    init(timeZone: TimeZone? = nil) {
        isoFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]
        isoFormatterWithoutSeconds.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate
        ]
        
        shortDateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let timeZone = timeZone {
            isoFormatter.timeZone = timeZone
            isoFormatterWithoutSeconds.timeZone = timeZone
            shortDateFormatter.timeZone = timeZone
        }
    }
    
    // MARK: - API
    
    func date(from string: String) -> Date? {
        if let dateWithTime = (isoFormatter.date(from: string + "Z") ?? isoFormatter.date(from: string)) {
            return dateWithTime
        }
        if let dateWithTime = (isoFormatterWithoutSeconds.date(from: string + "Z") ?? isoFormatterWithoutSeconds.date(from: string)) {
            return dateWithTime
        }
        if let date = shortDateFormatter.date(from: string) {
            return date
        }
        return nil
    }
    
}
