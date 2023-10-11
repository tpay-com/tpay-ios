//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DependenciesContainer: ServiceContainer {

    // MARK: - Properties

    private let resolver: Resolver

    // MARK: - Lifecycle

    convenience init() {
        self.init(with: Resolver.main)
    }

    init(with resolver: Resolver) {
        self.resolver = resolver
    }

    func reset() {
        ResolverScope.cached.reset()
    }
}

// MARK: - ServiceRegistry

extension DependenciesContainer {
    func register<Service>(_ type: Service.Type, name: String?, factory: @escaping () -> Service?) -> ServiceEntry<Service> {
        let serviceName = name.map { Resolver.Name($0) }
        let options = resolver.register(type, name: serviceName, factory: factory)
        return wrapped(options)
    }

    func register<Service>(_ type: Service.Type, name: String?, factory: @escaping (ServiceResolver) -> Service?) -> ServiceEntry<Service> {
        let serviceName = name.map { Resolver.Name($0) }
        let options = resolver.register(type, name: serviceName) { _ in factory(self) }
        return wrapped(options)
    }

    func register<Service>(_ type: Service.Type, name: String?, factory: @escaping (ServiceResolver, Any?) -> Service?) -> ServiceEntry<Service> {
        let serviceName = name.map { Resolver.Name($0) }
        let options = resolver.register(type, name: serviceName) { _, arg in factory(self, arg) }
        return wrapped(options)
    }

    private func wrapped<Service>(_ options: ResolverOptions<Service>) -> ServiceEntry<Service> {
        ServiceEntry<Service>(with: options)
    }
}

// MARK: - ServiceResolver

extension DependenciesContainer {
    func resolve<Service>() -> Service {
        resolver.resolve(Service.self, name: nil, args: nil)
    }

    func resolve<Service>(_ type: Service.Type, name: String? = nil, args: Any? = nil) -> Service {
        let serviceName = name.map { Resolver.Name($0) }
        return resolver.resolve(type, name: serviceName, args: args)
    }

    func optional<Service>() -> Service? {
        resolver.optional(Service.self, name: nil, args: nil)
    }

    func optional<Service>(_ type: Service.Type, name: String?, args: Any?) -> Service? {
        let serviceName = name.map { Resolver.Name($0) }
        return resolver.optional(type, name: serviceName, args: args)
    }
}
