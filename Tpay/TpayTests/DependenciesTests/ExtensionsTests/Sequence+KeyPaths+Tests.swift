//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class Sequence_KeyPaths_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_MapKeyPath() {
        let sut = [Model(number: 1),
                   Model(number: 2)]
        expect(sut.map(\.number)).to(equal([1,2]))
    }
    
    func test_CompactMapKeyPath() {
        let sut = [OptionalModel(number: 1),
                   OptionalModel(number: nil)]
        expect(sut.compactMap(\.number)).to(equal([1]))
    }
    
}

private extension Sequence_KeyPaths_Tests {
    
    struct Model {
        
        let number: Int
        
    }
    
    struct OptionalModel {
        
        let number: Int?
        
    }
    
}
