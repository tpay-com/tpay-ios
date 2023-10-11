//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Invocation_Errors_Tests: XCTestCase {

    // MARK: - Tests
    
    func test_DescriptionIsNotEmpty() {
        expect(Invocation.Errors.completedWithoutResults.errorDescription).toNot(beNil())
    }
    
}
