//
//  Copyright © 2022 Tpay. All rights reserved.
//

enum ContentType: HttpHeader, Equatable {
    
    // MARK: - Cases
    
    case none
    case json
    
    // MARK: - Properties
    
    var rawValue: String {
        switch self {
        case .none:
            return .empty
        case .json:
            return "application/json"
        }
    }
    
    var key: String { "Content-Type" }
    var value: String { rawValue }
    
}
