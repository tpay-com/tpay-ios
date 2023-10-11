//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Array {

    func sorted<ValueType: Comparable>(by keyPath: KeyPath<Element, ValueType>) -> Self {
        sorted { lhs, rhs in lhs[keyPath: keyPath] < rhs[keyPath: keyPath] }
    }

}
