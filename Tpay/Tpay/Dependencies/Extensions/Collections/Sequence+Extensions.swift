//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Sequence {
    
    func compacted<ResultType>() -> [ResultType] where Element == ResultType? { compactMap { $0 } }

}
