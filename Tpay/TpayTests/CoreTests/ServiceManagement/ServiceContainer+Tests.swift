//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class ServiceContainer_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var sut: ServiceContainer!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        let resolver = Resolver()
        sut = DependenciesContainer(with: resolver)
    }
    
    // MARK: - Tests
    
    func test_GraphScopeServicesResolving() {
        sut.register(Resolvee.self, name: nil) { _ in Resolvee() }
            .scope(.graph)
        
        let resolvee_1: Resolvee = sut.resolve()
        let resolvee_2: Resolvee = sut.resolve()

        XCTAssertFalse(resolvee_1 === resolvee_2)
    }
    
    func test_CachedScopeServicesResolving() {
        sut.register(Resolvee.self, name: nil) { _ in Resolvee() }
            .scope(.cached)
        
        let resolvee_1: Resolvee = sut.resolve()
        let resolvee_2: Resolvee = sut.resolve()

        XCTAssertTrue(resolvee_1 === resolvee_2)
    }
    
    func test_ResetCachedServices() {
        sut.register(Resolvee.self, name: nil) { _ in Resolvee() }
            .scope(.cached)
    
        let resolvee_1: Resolvee = sut.resolve()
        sut.reset()
        let resolvee_2: Resolvee = sut.resolve()
        XCTAssertFalse(resolvee_1 === resolvee_2)
    }
}

private extension ServiceContainer_Tests {
    
    final class Resolvee { }
}
