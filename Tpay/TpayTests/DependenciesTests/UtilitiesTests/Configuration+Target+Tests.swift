//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Configuration_Target_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_DefaultStatus() {
        expect(Target.current) == .production
    }
    
    func test_ConfigureTarget() {
        Configuration.Target.setup(as: .develop)
        expect(Target.current) == .develop
        Configuration.Target.setup(as: .test)
        expect(Target.current) == .test
        Configuration.Target.setup(as: .production)
        expect(Target.current) == .production
    }
    
}
