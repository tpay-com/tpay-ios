//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultJSONDecoder: ObjectDecoder {
    
    // MARK: - Properties
    
    private let decoder: JSONDecoder
    private let dateDecoder: DateDecoder
    
    // MARK: - Initializers
    
    init(using decoder: JSONDecoder, dateDecoder: DateDecoder) {
        self.decoder = decoder
        self.dateDecoder = dateDecoder
        
        decoder.dateDecodingStrategy = .custom(dateDecoder.date(from:))
    }
    
    // MARK: - API
    
    func decode<ResultType: Decodable>(_ type: ResultType.Type, from data: Data) throws -> ResultType {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw error
        }
    }
}
