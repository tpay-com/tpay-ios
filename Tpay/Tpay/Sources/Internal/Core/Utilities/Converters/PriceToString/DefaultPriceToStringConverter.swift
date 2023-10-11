//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultPriceToStringConverter: PriceToStringConverter {
    
    // MARK: - Properties
    
    private let numberFormatter = NumberFormatter()
    
    // MARK: - Initializers
    
    init(locale: Locale? = nil) {
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        numberFormatter.numberStyle = .currency
        
        if let locale = locale {
            numberFormatter.locale = locale
        }
    }
    
    // MARK: - API
    
    func string(from price: Domain.Price) -> String {
        numberFormatter.currencyCode = price.currency
        return numberFormatter.string(from: price.amount as NSNumber).value(or: .empty)
    }
    
}
