//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol PriceToStringConverter: AnyObject {
    
    // MARK: - API
    
    func string(from price: Domain.Price) -> String
}
