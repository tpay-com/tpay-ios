//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

extension NSAttributedString.Builder {
    
    @discardableResult
    func add(_ text: String, lineHeight: LineHeight, textAlignment: NSTextAlignment = .natural) -> Self {
        guard case let .fixed(lineHeight) = lineHeight else {
            return add(text, with: .textAlignment(textAlignment))
        }
        return add(text, with: .minimumLineHeight(lineHeight), .textAlignment(textAlignment))
    }
}
