//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Invocation_Retainer_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = Invocation.Retainer()
    
    // MARK: - Tests
    
    func test_IsRetainObjects() throws {
        var object: NSObject? = NSObject()
        weak var reference = object
        
        expect(reference).toNot(beNil())
        
        let uuid = UUID()
        sut.retain(try XCTUnwrap(object), for: uuid)
        
        object = nil
        expect(reference).toNot(beNil())
        
        sut.releaseObject(with: uuid)
        
        expect(reference).to(beNil())
    }
    
}
