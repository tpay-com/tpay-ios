//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation
import Nimble
@testable import Tpay
import XCTest

final class MerchantDetails_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_MerchantGdprNoteWithoutHeadquarters() {
        let sut = Domain.MerchantDetails(displayName: Stub.merchantDisplayName,
                                         headquarters: nil,
                                         regulationsUrl: Stub.regulationsLink)
        
        expect(sut.merchantGdprNote) == "<span>Administratorem danych osobowych jest Merchant Inc..</br><a href='https://merchant.online'><b>Zapoznaj się z pełną treścią.</b></a></span>"
    }
    
    func test_MerchantGdprNoteWithHeadquarters() {
        let sut = Domain.MerchantDetails(displayName: Stub.merchantDisplayName,
                                         headquarters: Stub.merchantHeadquarters,
                                         regulationsUrl: Stub.regulationsLink)
        
        expect(sut.merchantGdprNote) == "<span>Administratorem danych osobowych jest Merchant Inc. z siedzibą w Washington D.C..</br><a href='https://merchant.online'><b>Zapoznaj się z pełną treścią.</b></a></span>"
    }
}

private extension MerchantDetails_Extensions_Tests {
    
    enum Stub {
        
        static let merchantDisplayName = "Merchant Inc."
        static let merchantHeadquarters = "Washington D.C."
        static let regulationsLink = URL(safeString: "https://merchant.online")
    }
}
