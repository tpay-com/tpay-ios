//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultDateDecoder: DateDecoder {
    
    // MARK: - Properties
    
    private let dateConverter: StringToDateConverter
    
    // MARK: - Initializers
    
    init(dateConverter: StringToDateConverter) {
        self.dateConverter = dateConverter
    }
    
    // MARK: - API
    
    func date(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        guard let date = dateConverter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unable to convert \"\(dateString)\" to valid date object")
        }
        
        return date
    }    
}
