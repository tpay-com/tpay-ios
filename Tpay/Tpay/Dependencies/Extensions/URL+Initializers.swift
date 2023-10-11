//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension URL {
    
    init(staticString: StaticString) {
        guard let url = URL(string: staticString.description) else {
            preconditionFailure("Invalid static URL string: \(staticString)")
        }
        self = url
    }
    
    init(safeString: String) {
        guard let url = URL(string: safeString) else {
            preconditionFailure("Invalid URL string: \(safeString)")
        }
        self = url
    }
    
}
