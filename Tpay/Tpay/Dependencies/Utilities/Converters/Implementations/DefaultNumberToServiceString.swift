//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultNumberToServiceString: NumberToServiceString {
    
    // MARK: - Properties
    
    private let integerFormatter = NumberFormatter()
    private let decimalFormatter = NumberFormatter()
    
    // MARK: - Initializers
    
    init() {
        integerFormatter.numberStyle = .decimal
        integerFormatter.groupingSeparator = .empty
        integerFormatter.maximumFractionDigits = 0
        
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.groupingSeparator = .empty
        decimalFormatter.decimalSeparator = .dot
        decimalFormatter.minimumFractionDigits = 2
        decimalFormatter.maximumFractionDigits = 2
    }
    
    // MARK: - API
    
    func string(from value: Int) -> String {
        integerFormatter.string(from: value as NSNumber).value(or: .empty)
    }
    
    func string(from value: Decimal) -> String {
        decimalFormatter.string(from: value as NSNumber).value(or: .empty)
    }
    
}
