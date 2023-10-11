//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension String {
    
    var isNotEmpty: Bool { isEmpty == false }
    var base64: String { Data(utf8).base64EncodedString() }
    var isNewLine: Bool { self == String.newLine }
}
