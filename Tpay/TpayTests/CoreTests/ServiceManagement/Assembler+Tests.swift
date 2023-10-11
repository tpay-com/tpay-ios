//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class Assembler_Tests: XCTestCase {
    
    // MARK: - Tests

    func test_AssembleIntoDefaultContainer() {
        _ = Assembler([TestAssembly()])
        let dependenciesContainer = DependenciesContainer()
        expect(dependenciesContainer.resolve(Resolvee.self)).toNot(beNil())
    }
    
    func test_AssembleIntoPassedContainer() {
        let resolver = Resolver()
        let container = DependenciesContainer(with: resolver)

        _ = Assembler(with: container, assemblies: [TestAssembly()])
        
        expect(container.resolve(Resolvee.self)).toNot(beNil())
    }
}

private extension Assembler_Tests {
    
    final class TestAssembly: Assembly {
        
        func assemble(into container: ServiceContainer) {
            container.register(Resolvee.self, name: nil) {
                Resolvee()
            }.scope(.graph)
        }
    }
    
    final class Resolvee { }
}
