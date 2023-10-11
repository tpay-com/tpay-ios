//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultDateEncoder: DateEncoder {
    
    // MARK: - Properties
    
    private let calendar: Calendar
    private let dateConverter: DateToServiceStringConverter
    
    // MARK: - Initializers
    
    init(dateConverter: DateToServiceStringConverter) {
        self.calendar = .current
        self.dateConverter = dateConverter
    }
    
    // MARK: - API
    
    func encode(date: Date, into encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
    
        switch (components.hour, components.minute, components.second) {
        case (nil, nil, nil): try container.encode(dateConverter.dateString(from: date))
        case (0, 0, 0): try container.encode(dateConverter.dateString(from: date))
        default: try container.encode(dateConverter.dateAndTimeString(from: date))
        }
    }
}
