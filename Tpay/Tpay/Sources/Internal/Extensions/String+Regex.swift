//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension String {
    
    func matches(_ regex: String) -> Bool {
        range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
