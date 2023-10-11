//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Dictionary_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_IsNotEmpty() {
        let emptyDictionary = Dictionary<Int, Int>()
        expect(emptyDictionary.isNotEmpty).to(beFalse())
        
        let notEmptyDictionary = [1 : 1]
        expect(notEmptyDictionary.isNotEmpty).to(beTrue())
    }
    
}
