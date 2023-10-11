//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Array_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_IsNotEmpty() {
        let emptyArray = [Int]()
        expect(emptyArray.isNotEmpty).to(beFalse())
        
        let notEmptyArray = [1, 2]
        expect(notEmptyArray.isNotEmpty).to(beTrue())
    }
    
    func test_AppendElementIfCondition() {
        var sut = [Int]()
        expect(sut).to(equal([]))
        sut.append(1, if: true)
        expect(sut).to(equal([1]))
        sut.append(2, if: false)
        expect(sut).to(equal([1]))
        sut.append(2, if: true)
        expect(sut).to(equal([1, 2]))
    }
    
    func test_AppendContentsOfCollectionIfCondition() {
        var sut = [Int]()
        let contentsSource = [1, 2]
        expect(sut).to(equal([]))
        sut.append(contentsOf: contentsSource, if: true)
        expect(sut).to(equal([1, 2]))
        sut.append(contentsOf: contentsSource, if: false)
        expect(sut).to(equal([1, 2]))
        sut.append(contentsOf: contentsSource, if: true)
        expect(sut).to(equal([1, 2, 1, 2]))
    }
    
    func test_DistinctWithoutRepeatingElements() {
        let sut = [Model(id: 1),
                   Model(id: 2)]
        expect(sut.count).to(be(2))
        expect(sut.distinct(by: \.id).count).to(be(2))
        expect(sut.map(\.id)).to(equal([1, 2]))
    }
    
    func test_DistinctWithRepeatingElements() {
        let sut = [Model(id: 1),
                   Model(id: 2),
                   Model(id: 2),
                   Model(id: 3),
                   Model(id: 3),
                   Model(id: 3)]
        expect(sut.count).to(be(6))
        expect(sut.map(\.id)).to(equal([1, 2, 2, 3, 3, 3]))
        expect(sut.distinct(by: \.id).count).to(be(3))
        expect(sut.distinct(by: \.id).map(\.id)).to(equal([1, 2, 3]))
    }
    
}

private extension Array_Extensions_Tests {
    
    struct Model: Hashable {
        
        let id: Int
        
    }
    
}
