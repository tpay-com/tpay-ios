//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Data_Properties_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_IsNotEmpty() {
        let emptyData = Data()
        expect(emptyData.isNotEmpty).to(beFalse())
        
        let notEmptyData = Data([1])
        expect(notEmptyData.isNotEmpty).to(beTrue())
    }
    
}
