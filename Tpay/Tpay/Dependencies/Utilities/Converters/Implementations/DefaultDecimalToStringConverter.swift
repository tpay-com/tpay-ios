//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultDecimalToStringConverter: DecimalToStringConverter {
    
    // MARK: - Properties
    
    private let numberFormatter = NumberFormatter()
    
    // MARK: - Initializers
    
    init(locale: Locale? = nil) {
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        if let locale = locale {
            numberFormatter.locale = locale
        }
    }
    
    // MARK: - API
    
    func string(from number: Decimal) -> String {
        numberFormatter.string(from: number as NSNumber).value(or: .empty)
    }
    
}
