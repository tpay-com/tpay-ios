//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct BadRequest: Decodable, Equatable {
    
    // MARK: - Properties
    
    var errors: [ServiceError] { serviceErrors.errors }
    
    private let serviceErrors: ServiceErrors
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.contains(.errors) {
            serviceErrors = try ServiceErrors(from: decoder)
            return
        }
        serviceErrors = ServiceErrors(errors: [])
    }
}

extension BadRequest {
    
    private enum CodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case errors
    }
}
