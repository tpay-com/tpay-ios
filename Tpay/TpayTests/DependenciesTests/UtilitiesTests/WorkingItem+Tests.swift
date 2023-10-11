//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class WorkingItem_Tests: XCTestCase {

    // MARK: - Tests

    func test_CancelCallAction() {
        waitUntil(timeout: .milliseconds(1)) { done in
            let item = WorkingItem { done() }
            item.cancel()
        }
    }

    func test_ReleaseCallAction() {
        waitUntil(timeout: .milliseconds(1)) { done in
            var item: WorkingItem? = WorkingItem { done() }
            _ = item
            item = nil
        }
    }

}
