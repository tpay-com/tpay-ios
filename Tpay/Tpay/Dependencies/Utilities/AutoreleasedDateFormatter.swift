//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class AutoreleasedDateFormatter: DateFormatter {

    // MARK: - API

    override func date(from string: String) -> Date? {
        autoreleasepool { super.date(from: string) }
    }

}
