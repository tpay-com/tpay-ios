//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation

extension Domain.MerchantDetails {
    
    var merchantGdprNote: String {
        guard let headquarters = headquarters else {
            return Strings.merchantGdprNoteWithoutHeadquarters(displayName, regulationsUrl.absoluteString)
        }
        return Strings.merchantGdprNoteWithHeadquarters(displayName, headquarters, regulationsUrl.absoluteString)
    }
}
