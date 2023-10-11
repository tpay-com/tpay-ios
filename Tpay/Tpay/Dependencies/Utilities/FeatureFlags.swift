//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct FeatureFlag: RawRepresentable, Equatable {
    
    var rawValue: String
    
    init(rawValue: String) { self.rawValue = rawValue }
    
}

typealias FeatureFlags = [FeatureFlag]

extension Array where Element == FeatureFlag {
    
    func isEnabled(feature flag: FeatureFlag) -> Bool {
        contains(flag)
    }
    
    mutating func enable(feature flag: FeatureFlag) {
        append(flag, if: !isEnabled(feature: flag))
    }
    
    mutating func disable(feature flag: FeatureFlag) {
        self = filter { $0 != flag }
    }
    
}
