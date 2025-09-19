//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Sequence {
    
    func map<ValueType>(_ keyPath: KeyPath<Element, ValueType>) -> [ValueType] { map { $0[keyPath: keyPath] } }
    func compactMap<ValueType>(_ keyPath: KeyPath<Element, ValueType?>) -> [ValueType] { compactMap { $0[keyPath: keyPath] } }
    
}
