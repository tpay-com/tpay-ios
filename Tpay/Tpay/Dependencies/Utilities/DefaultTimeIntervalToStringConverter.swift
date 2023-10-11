//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultTimeIntervalToStringConverter: TimeIntervalToStringConverter {
    
    // MARK: - Properties
    
    private let shortValueFormatter = DateComponentsFormatter()
    private let longValueFormatter = DateComponentsFormatter()
    
    // MARK: - Initializers
    
    init() {
        shortValueFormatter.allowedUnits = [.minute, .second]
        shortValueFormatter.unitsStyle = .positional
        shortValueFormatter.zeroFormattingBehavior = .pad
        
        longValueFormatter.allowedUnits = [.hour, .minute, .second]
        longValueFormatter.unitsStyle = .positional
        longValueFormatter.zeroFormattingBehavior = .pad
    }
    
    // MARK: - API
    
    func duration(from timeInterval: TimeInterval) -> String {
        guard timeInterval > .zero else { return shortValueFormatter.string(from: timeInterval).value(or: .empty) }
        switch timeInterval {
        case .zero ..< .hour: return shortValueFormatter.string(from: timeInterval).value(or: .empty)
        default: return longValueFormatter.string(from: timeInterval).value(or: .empty)
        }        
    }
    
}
