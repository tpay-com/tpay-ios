//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Array_Sequence_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_FlattedForNonNilArray() {
        let sut = [[1], [2], [3]]
        expect(sut.flatted()).to(equal([1, 2, 3]))
    }
    
    func test_FlattedForNilArray() {
        let sut: [[Int?]] = [[nil], [nil], [nil]]
        expect(sut.flatted()).to(equal([nil, nil, nil]))
    }
    
    func test_FlattedForMixedArray() {
        let sut = [[1], [nil], [3]]
        expect(sut.flatted()).to(equal([1, nil, 3]))
    }
    
}
