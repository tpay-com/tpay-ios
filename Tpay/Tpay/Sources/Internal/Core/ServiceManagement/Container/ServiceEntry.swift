//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class ServiceEntry<Type> {

    // MARK: - Parameters

    private let options: ResolverOptions<Type>

    // MARK: - Lifecycle

    init(with options: ResolverOptions<Type>) {
        self.options = options
    }

    // MARK: - Functionality

    @discardableResult
    final func implements<Protocol>(_ type: Protocol.Type, name: String? = nil) -> Self {
        let serviceName = name.map { Resolver.Name($0) }
        options.implements(type, name: serviceName)
        return self
    }

    @discardableResult
    final func scope(_ scope: RegistrationScope) -> Self {
        switch scope {
        case .graph:
            options.scope(ResolverScope.graph)
        case .cached:
            options.scope(ResolverScope.cached)
        }
        return self
    }
}
