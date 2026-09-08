//
//  Copyright © 2026 Tpay. All rights reserved.
//

import Foundation

protocol DateProvider {

    // MARK: - Properties

    var now: Date { get }
}

struct DefaultDateProvider: DateProvider {

    // MARK: - Properties

    var now: Date { Date() }
}
