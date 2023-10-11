//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultIntegerToStringConverter: IntegerToStringConverter {
    
    // MARK: - Properties
    
    private let formatter: NumberFormatter
    
    // MARK: - Initializers
    
    init(locale: Locale? = nil) {
        formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        if let locale = locale {
            formatter.locale = locale
        }
    }
    
    // MARK: - API
    
    func string(from integer: Int) -> String {
        formatter.string(from: integer as NSNumber).value(or: .empty)
    }
    
}
