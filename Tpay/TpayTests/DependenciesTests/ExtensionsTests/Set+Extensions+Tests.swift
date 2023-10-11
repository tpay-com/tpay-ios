//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Set_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_IsNotEmpty() {
        let emptySet = Set<Int>()
        expect(emptySet.isNotEmpty).to(beFalse())
        
        let notEmptySet = Set<Int>(arrayLiteral: 1)
        expect(notEmptySet.isNotEmpty).to(beTrue())
    }
    
}
