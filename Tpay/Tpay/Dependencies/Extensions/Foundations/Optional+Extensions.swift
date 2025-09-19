//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Optional {
    
    func value(or value: @autoclosure () -> Wrapped) -> Wrapped {
        switch self {
        case .none: return value()
        case let .some(value): return value
        }
    }
    
    func value(orThrow error: Error) throws -> Wrapped {
        switch self {
        case .none: throw error
        case let .some(value): return value
        }
    }
    
}
