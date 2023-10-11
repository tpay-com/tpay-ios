//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Sequence_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_CompactedForNonNilArray() {
        let sut: [Int?] = [1, 2, 3]
        expect(sut.compacted()).to(equal([1, 2, 3]))
    }
    
    func test_CompactedForNilArray() {
        let sut: [Int?] = [nil, nil, nil]
        expect(sut.compacted()).to(equal([]))
    }
    
    func test_CompactedForMixedArray() {
        let sut = [1, nil, 3]
        expect(sut.compacted()).to(equal([1, 3]))
    }
    
}
