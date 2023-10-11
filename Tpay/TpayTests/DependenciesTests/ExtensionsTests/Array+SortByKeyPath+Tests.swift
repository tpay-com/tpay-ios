//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Array_SortByKeyPath_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_sortSortedArray() {
        let sut = [Model(id: 1),
                   Model(id: 2),
                   Model(id: 3)]
        expect(sut.map(\.id)).to(equal([1, 2, 3]))
        expect(sut.sorted(by: \.id).map(\.id)).to(equal([1, 2, 3]))
    }
    
    func test_sortUnsortedArray() {
        let sut = [Model(id: 2),
                   Model(id: 1),
                   Model(id: 3)]
        expect(sut.map(\.id)).to(equal([2, 1, 3]))
        expect(sut.sorted(by: \.id).map(\.id)).to(equal([1, 2, 3]))
    }
    
}

private extension Array_SortByKeyPath_Tests {
    
    struct Model {
        
        let id: Int
        
    }
    
}
