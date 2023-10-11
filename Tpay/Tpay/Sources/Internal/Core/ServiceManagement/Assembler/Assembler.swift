//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class Assembler {

    // MARK: - Properties

    private let container: ServiceContainer

    // MARK: - Lifecycle

    convenience init(_ assemblies: [Assembly]) {
        self.init(with: DependenciesContainer(), assemblies: assemblies)
    }

    init(with container: ServiceContainer, assemblies: [Assembly]) {
        self.container = container
        assemble(assemblies)
    }

    // MARK: - Private

    private func assemble(_ assemblies: [Assembly]) {
        assemblies.forEach { assembly in assembly.assemble(into: container) }
    }
}
