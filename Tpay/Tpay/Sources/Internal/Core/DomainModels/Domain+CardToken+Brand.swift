//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Domain.CardToken {
    
    enum Brand {
        
        // MARK: - Cases
        
        case mastercard
        case visa
        
        case other(String)
    }
}

extension Domain.CardToken.Brand: RawRepresentable, Equatable {
    
    typealias RawValue = String
    
    // MARK: - Initializers
    
    init?(rawValue: String) {
        switch rawValue {
        case String.mastercard:
            self = .mastercard
        case String.visa:
            self = .visa
        default:
            self = .other(rawValue)
        }
    }
    
    // MARK: - Properties
    
    var rawValue: String {
        switch self {
        case .mastercard:
            return String.mastercard
        case .visa:
            return String.visa
        case let .other(brandName):
            return brandName
        }
    }
}

private extension String {
    
    // MARK: - Properties
    
    static let mastercard = "Mastercard"
    static let visa = "Visa"
}
