//
// Resolver.swift
//
// GitHub Repo and Documentation: https://github.com/hmlongco/Resolver
//
// Copyright © 2017 Michael Long. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#if os(iOS)
import UIKit
import SwiftUI
#elseif os(macOS) || os(tvOS) || os(watchOS)
import Foundation
import SwiftUI
#else
import Foundation
#endif

// swiftlint:disable file_length

protocol ResolverRegistering {
    static func registerAllServices()
}

/// The Resolving protocol is used to make the Resolver registries available to a given class.
protocol Resolving {
    var resolver: Resolver { get }
}

extension Resolving {
    var resolver: Resolver {
        return Resolver.root
    }
}

/// Resolver is a Dependency Injection registry that registers Services for later resolution and
/// injection into newly constructed instances.
final class Resolver {

    // MARK: - Defaults

    /// Default registry used by the static Registration functions.
    static var main: Resolver = Resolver()
    /// Default registry used by the static Resolution functions and by the Resolving protocol.
    static var root: Resolver = main
    /// Default scope applied when registering new objects.
    static var defaultScope: ResolverScope = .graph
    /// Internal scope cache used for .scope(.container)
    lazy var cache: ResolverScope = ResolverScopeCache()

    // MARK: - Lifecycle

    /// Initialize with optional child scope.
    /// If child is provided this container is searched for registrations first, then any of its children.
    init(child: Resolver? = nil) {
        if let child = child {
            self.childContainers.append(child)
        }
    }

    /// Initializer which maintained Resolver 1.0's "parent" functionality even when multiple child scopes were added in 1.4.3.
    @available(swift, deprecated: 5.0, message: "Please use Resolver(child:).")
    init(parent: Resolver) {
        self.childContainers.append(parent)
    }

    /// Adds a child container to this container. Children will be searched if this container fails to find a registration factory
    /// that matches the desired type.
    func add(child: Resolver) {
        lock.lock()
        defer { lock.unlock() }
        self.childContainers.append(child)
    }

    /// Call function to force one-time initialization of the Resolver registries. Usually not needed as functionality
    /// occurs automatically the first time a resolution function is called.
    final func registerServices() {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
    }

    /// Call function to force one-time initialization of the Resolver registries. Usually not needed as functionality
    /// occurs automatically the first time a resolution function is called.
    static var registerServices: (() -> Void)? = {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
    }

    /// Called to effectively reset Resolver to its initial state, including recalling registerAllServices if it was provided. This will
    /// also reset the three known caches: application, cached, shared.
    static func reset() {
        lock.lock()
        defer { lock.unlock() }
        main = Resolver()
        root = main
        ResolverScope.application.reset()
        ResolverScope.cached.reset()
        ResolverScope.shared.reset()
        registrationNeeded = true
    }

    // MARK: - Service Registration

    /// Static shortcut function used to register a specifc Service type and its instantiating factory method.
    ///
    /// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
    /// - parameter name: Named variant of Service being registered.
    /// - parameter factory: Closure that constructs and returns instances of the Service.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    static func register<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                         factory: @escaping ResolverFactory<Service>) -> ResolverOptions<Service> {
        return main.register(type, name: name, factory: factory)
    }

    /// Static shortcut function used to register a specific Service type and its instantiating factory method.
    ///
    /// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
    /// - parameter name: Named variant of Service being registered.
    /// - parameter factory: Closure that constructs and returns instances of the Service.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    static func register<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                         factory: @escaping ResolverFactoryResolver<Service>) -> ResolverOptions<Service> {
        return main.register(type, name: name, factory: factory)
    }

    /// Static shortcut function used to register a specific Service type and its instantiating factory method with multiple argument support.
    ///
    /// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
    /// - parameter name: Named variant of Service being registered.
    /// - parameter factory: Closure that accepts arguments and constructs and returns instances of the Service.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    static func register<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                         factory: @escaping ResolverFactoryArgumentsN<Service>) -> ResolverOptions<Service> {
        return main.register(type, name: name, factory: factory)
    }

    /// Registers a specific Service type and its instantiating factory method.
    ///
    /// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
    /// - parameter name: Named variant of Service being registered.
    /// - parameter factory: Closure that constructs and returns instances of the Service.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    final func register<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                        factory: @escaping ResolverFactory<Service>) -> ResolverOptions<Service> {
        lock.lock()
        defer { lock.unlock() }
        let key = Int(bitPattern: ObjectIdentifier(Service.self))
        let factory: ResolverFactoryAnyArguments = { (_,_) in factory() }
        let registration = ResolverRegistration<Service>(resolver: self, key: key, name: name, factory: factory)
        add(registration: registration, with: key, name: name)
        return ResolverOptions(registration: registration)
    }

    /// Registers a specific Service type and its instantiating factory method.
    ///
    /// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
    /// - parameter name: Named variant of Service being registered.
    /// - parameter factory: Closure that constructs and returns instances of the Service.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    final func register<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                        factory: @escaping ResolverFactoryResolver<Service>) -> ResolverOptions<Service> {
        lock.lock()
        defer { lock.unlock() }
        let key = Int(bitPattern: ObjectIdentifier(Service.self))
        let factory: ResolverFactoryAnyArguments = { (r,_) in factory(r) }
        let registration = ResolverRegistration<Service>(resolver: self, key: key, name: name, factory: factory)
        add(registration: registration, with: key, name: name)
        return ResolverOptions(registration: registration)
    }

    /// Registers a specific Service type and its instantiating factory method with multiple argument support.
    ///
    /// - parameter type: Type of Service being registered. Optional, may be inferred by factory result type.
    /// - parameter name: Named variant of Service being registered.
    /// - parameter factory: Closure that accepts arguments and constructs and returns instances of the Service.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    final func register<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil,
                                        factory: @escaping ResolverFactoryArgumentsN<Service>) -> ResolverOptions<Service> {
        lock.lock()
        defer { lock.unlock() }
        let key = Int(bitPattern: ObjectIdentifier(Service.self))
        let factory: ResolverFactoryAnyArguments = { (r,a) in factory(r, Args(a)) }
        let registration = ResolverRegistration<Service>(resolver: self, key: key, name: name, factory: factory )
        add(registration: registration, with: key, name: name)
        return ResolverOptions(registration: registration)
    }

    // MARK: - Service Resolution

    /// Static function calls the root registry to resolve a given Service type.
    ///
    /// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
    /// - parameter name: Named variant of Service being resolved.
    /// - parameter args: Optional arguments that may be passed to registration factory.
    ///
    /// - returns: Instance of specified Service.
    static func resolve<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil, args: Any? = nil) -> Service {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = root.lookup(type, name: name), let service = registration.resolve(resolver: root, args: args) {
            return service
        }
        fatalError("RESOLVER: '\(Service.self):\(name?.rawValue ?? "NONAME")' not resolved. To disambiguate optionals use resolver.optional().")
    }

    /// Resolves and returns an instance of the given Service type from the current registry or from its
    /// parent registries.
    ///
    /// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
    /// - parameter name: Named variant of Service being resolved.
    /// - parameter args: Optional arguments that may be passed to registration factory.
    ///
    /// - returns: Instance of specified Service.
    ///
    final func resolve<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil, args: Any? = nil) -> Service {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = lookup(type, name: name), let service = registration.resolve(resolver: self, args: args) {
            return service
        }
        fatalError("RESOLVER: '\(Service.self):\(name?.rawValue ?? "NONAME")' not resolved. To disambiguate optionals use resolver.optional().")
    }

    /// Static function calls the root registry to resolve an optional Service type.
    ///
    /// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
    /// - parameter name: Named variant of Service being resolved.
    /// - parameter args: Optional arguments that may be passed to registration factory.
    ///
    /// - returns: Instance of specified Service.
    ///
    static func optional<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil, args: Any? = nil) -> Service? {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = root.lookup(type, name: name), let service = registration.resolve(resolver: root, args: args) {
            return service
        }
        return nil
    }

    /// Resolves and returns an optional instance of the given Service type from the current registry or
    /// from its parent registries.
    ///
    /// - parameter type: Type of Service being resolved. Optional, may be inferred by assignment result type.
    /// - parameter name: Named variant of Service being resolved.
    /// - parameter args: Optional arguments that may be passed to registration factory.
    ///
    /// - returns: Instance of specified Service.
    ///
    final func optional<Service>(_ type: Service.Type = Service.self, name: Resolver.Name? = nil, args: Any? = nil) -> Service? {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = lookup(type, name: name), let service = registration.resolve(resolver: self, args: args) {
            return service
        }
        return nil
    }

    // MARK: - Internal

    /// Internal function searches the current and child registries for a ResolverRegistration<Service> that matches
    /// the supplied type and name.
    private final func lookup<Service>(_ type: Service.Type, name: Resolver.Name?) -> ResolverRegistration<Service>? {
        let key = Int(bitPattern: ObjectIdentifier(Service.self))
        if let name = name?.rawValue {
            if let registration = namedRegistrations["\(key):\(name)"] as? ResolverRegistration<Service> {
                return registration
            }
        } else if let registration = typedRegistrations[key] as? ResolverRegistration<Service> {
            return registration
        }
        for child in childContainers {
            if let registration = child.lookup(type, name: name) {
                return registration
            }
        }
        return nil
    }

    /// Internal function adds a new registration to the proper container.
    private final func add<Service>(registration: ResolverRegistration<Service>, with key: Int, name: Resolver.Name?) {
        if let name = name?.rawValue {
            namedRegistrations["\(key):\(name)"] = registration
        } else {
            typedRegistrations[key] = registration
        }
    }

    private let NONAME = "*"
    private let lock = Resolver.lock
    private var childContainers: [Resolver] = []
    private var typedRegistrations = [Int : Any]()
    private var namedRegistrations = [String : Any]()
}

/// Resolving an instance of a service is a recursive process (service A needs a B which needs a C).
private final class ResolverRecursiveLock {
    init() {
        pthread_mutexattr_init(&recursiveMutexAttr)
        pthread_mutexattr_settype(&recursiveMutexAttr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&recursiveMutex, &recursiveMutexAttr)
    }
    @inline(__always)
    final func lock() {
        pthread_mutex_lock(&recursiveMutex)
    }
    @inline(__always)
    final func unlock() {
        pthread_mutex_unlock(&recursiveMutex)
    }
    private var recursiveMutex = pthread_mutex_t()
    private var recursiveMutexAttr = pthread_mutexattr_t()
}

extension Resolver {
    fileprivate static let lock = ResolverRecursiveLock()
}

/// Resolver Service Name Space Support
extension Resolver {

    /// Internal class used by Resolver for typed name space support.
    struct Name: ExpressibleByStringLiteral, Hashable, Equatable {
        let rawValue: String
        init(_ rawValue: String) {
            self.rawValue = rawValue
        }
        init(stringLiteral: String) {
            self.rawValue = stringLiteral
        }
        static func name(fromString string: String?) -> Name? {
            if let string = string { return Name(string) }
            return nil
        }
        static func == (lhs: Name, rhs: Name) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }
    }

}

/// Resolver Multiple Argument Support
extension Resolver {

    /// Internal class used by Resolver for multiple argument support.
    struct Args {

        private var args: [String:Any?]

        init(_ args: Any?) {
            if let args = args as? Args {
                self.args = args.args
            } else if let args = args as? [String:Any?] {
                self.args = args
            } else {
                self.args = ["" : args]
            }
        }

        #if swift(>=5.2)
        func callAsFunction<T>() -> T {
            assert(args.count == 1, "argument order indeterminate, use keyed arguments")
            return (args.first?.value as? T)!
        }

        func callAsFunction<T>(_ key: String) -> T {
            return (args[key] as? T)!
        }
        #endif

        func optional<T>() -> T? {
            return args.first?.value as? T
        }

        func optional<T>(_ key: String) -> T? {
            return args[key] as? T
        }

        func get<T>() -> T {
            assert(args.count == 1, "argument order indeterminate, use keyed arguments")
            return (args.first?.value as? T)!
        }

        func get<T>(_ key: String) -> T {
            return (args[key] as? T)!
        }

    }

}

// Registration Internals

private var registrationNeeded: Bool = true

@inline(__always)
private func registrationCheck() {
    guard registrationNeeded else {
        return
    }
    if let registering = (Resolver.root as Any) as? ResolverRegistering {
        type(of: registering).registerAllServices()
    }
    registrationNeeded = false
}

typealias ResolverFactory<Service> = () -> Service?
typealias ResolverFactoryResolver<Service> = (_ resolver: Resolver) -> Service?
typealias ResolverFactoryArgumentsN<Service> = (_ resolver: Resolver, _ args: Resolver.Args) -> Service?
typealias ResolverFactoryAnyArguments<Service> = (_ resolver: Resolver, _ args: Any?) -> Service?
typealias ResolverFactoryMutator<Service> = (_ resolver: Resolver, _ service: Service) -> Void
typealias ResolverFactoryMutatorArgumentsN<Service> = (_ resolver: Resolver, _ service: Service, _ args: Resolver.Args) -> Void

/// A ResolverOptions instance is returned by a registration function in order to allow additional configuration. (e.g. scopes, etc.)
struct ResolverOptions<Service> {

    // MARK: - Parameters

    var registration: ResolverRegistration<Service>

    // MARK: - Fuctionality

    /// Indicates that the registered Service also implements a specific protocol that may be resolved on
    /// its own.
    ///
    /// - parameter type: Type of protocol being registered.
    /// - parameter name: Named variant of protocol being registered.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    func implements<Protocol>(_ type: Protocol.Type, name: Resolver.Name? = nil) -> ResolverOptions<Service> {
        registration.resolver?.register(type.self, name: name) { r, args in r.resolve(Service.self, args: args) as? Protocol }
        return self
    }

    /// Allows easy assignment of injected properties into resolved Service.
    ///
    /// - parameter block: Resolution block.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    func resolveProperties(_ block: @escaping ResolverFactoryMutator<Service>) -> ResolverOptions<Service> {
        registration.update { existingFactory in
            return { (resolver, args) in
                guard let service = existingFactory(resolver, args) else {
                    return nil
                }
                block(resolver, service)
                return service
            }
        }
        return self
    }

    /// Allows easy assignment of injected properties into resolved Service.
    ///
    /// - parameter block: Resolution block that also receives resolution arguments.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    func resolveProperties(_ block: @escaping ResolverFactoryMutatorArgumentsN<Service>) -> ResolverOptions<Service> {
        registration.update { existingFactory in
            return { (resolver, args) in
                guard let service = existingFactory(resolver, args) else {
                    return nil
                }
                block(resolver, service, Resolver.Args(args))
                return service
            }
        }
        return self
    }

    /// Defines scope in which requested Service may be cached.
    ///
    /// - parameter block: Resolution block.
    ///
    /// - returns: ResolverOptions instance that allows further customization of registered Service.
    ///
    @discardableResult
    func scope(_ scope: ResolverScope) -> ResolverOptions<Service> {
        registration.scope = scope
        return self
    }
}

/// ResolverRegistration base class provides storage for the registration keys, scope, and property mutator.
final class ResolverRegistration<Service> {

    let key: Int
    let cacheKey: String
    
    fileprivate var factory: ResolverFactoryAnyArguments<Service>
    fileprivate var scope: ResolverScope = Resolver.defaultScope
    
    fileprivate weak var resolver: Resolver?

    init(resolver: Resolver, key: Int, name: Resolver.Name?, factory: @escaping ResolverFactoryAnyArguments<Service>) {
        self.resolver = resolver
        self.key = key
        if let namedService = name {
            self.cacheKey = String(key) + ":" + namedService.rawValue
        } else {
            self.cacheKey = String(key)
        }
        self.factory = factory
    }

    /// Called by Resolver containers to resolve a registration. Depending on scope may return a previously cached instance.
    final func resolve(resolver: Resolver, args: Any?) -> Service? {
        return scope.resolve(registration: self, resolver: resolver, args: args)
    }
    
    /// Called by Resolver scopes to instantiate a new instance of a service.
    final func instantiate(resolver: Resolver, args: Any?) -> Service? {
        return factory(resolver, args)
    }
    
    /// Called by ResolverOptions to wrap a given service factory with new behavior.
    final func update(factory modifier: (_ factory: @escaping ResolverFactoryAnyArguments<Service>) -> ResolverFactoryAnyArguments<Service>) {
        self.factory = modifier(factory)
    }

}

// Scopes

/// Resolver scopes exist to control when resolution occurs and how resolved instances are cached. (If at all.)
protocol ResolverScopeType: AnyObject {
    func resolve<Service>(registration: ResolverRegistration<Service>, resolver: Resolver, args: Any?) -> Service?
    func reset()
}

class ResolverScope: ResolverScopeType {

    // Moved definitions to ResolverScope to allow for dot notation access

    /// All application scoped services exist for lifetime of the app. (e.g Singletons)
    static let application = ResolverScopeCache()
    /// Proxy to container's scope. Cache type depends on type supplied to container (default .cache)
    static let container = ResolverScopeContainer()
    /// Cached services exist for lifetime of the app or until their cache is reset.
    static let cached = ResolverScopeCache()
    /// Graph services are initialized once and only once during a given resolution cycle. This is the default scope.
    static let graph = ResolverScopeGraph()
    /// Shared services persist while strong references to them exist. They're then deallocated until the next resolve.
    static let shared = ResolverScopeShare()
    /// Unique services are created and initialized each and every time they're resolved.
    static let unique = ResolverScope()

    init() {}
    
    /// Core scope resolution simply instantiates new instance every time it's called (e.g. .unique)
    func resolve<Service>(registration: ResolverRegistration<Service>, resolver: Resolver, args: Any?) -> Service? {
        return registration.instantiate(resolver: resolver, args: args)
    }
    
    func reset() {
        // nothing to see here. move along.
    }
}

/// Cached services exist for lifetime of the app or until their cache is reset.
class ResolverScopeCache: ResolverScope {

    override init() {}

    override func resolve<Service>(registration: ResolverRegistration<Service>, resolver: Resolver, args: Any?) -> Service? {
        if let service = cachedServices[registration.cacheKey] as? Service {
            return service
        }
        let service = registration.instantiate(resolver: resolver, args: args)
        if let service = service {
            cachedServices[registration.cacheKey] = service
        }
        return service
    }

    override func reset() {
        cachedServices.removeAll()
    }

    fileprivate var cachedServices = [String : Any](minimumCapacity: 32)
}

/// Graph services are initialized once and only once during a given resolution cycle. This is the default scope.
final class ResolverScopeGraph: ResolverScope {

    override init() {}

    override final func resolve<Service>(registration: ResolverRegistration<Service>, resolver: Resolver, args: Any?) -> Service? {
        if let service = graph[registration.cacheKey] as? Service {
            return service
        }
        resolutionDepth = resolutionDepth + 1
        let service = registration.instantiate(resolver: resolver, args: args)
        resolutionDepth = resolutionDepth - 1
        if resolutionDepth == 0 {
            graph.removeAll()
        } else if let service = service, type(of: service as Any) is AnyClass {
            graph[registration.cacheKey] = service
        }
        return service
    }
    
    override final func reset() {}

    private var graph = [String : Any?](minimumCapacity: 32)
    private var resolutionDepth: Int = 0
}

/// Shared services persist while strong references to them exist. They're then deallocated until the next resolve.
final class ResolverScopeShare: ResolverScope {

    override init() {}

    override final func resolve<Service>(registration: ResolverRegistration<Service>, resolver: Resolver, args: Any?) -> Service? {
        if let service = cachedServices[registration.cacheKey]?.service as? Service {
            return service
        }
        let service = registration.instantiate(resolver: resolver, args: args)
        if let service = service, type(of: service as Any) is AnyClass {
            cachedServices[registration.cacheKey] = BoxWeak(service: service as AnyObject)
        }
        return service
    }

    override final func reset() {
        cachedServices.removeAll()
    }

    private struct BoxWeak {
        weak var service: AnyObject?
    }

    private var cachedServices = [String : BoxWeak](minimumCapacity: 32)
}

/// Unique services are created and initialized each and every time they're resolved. Performed by default implementation of ResolverScope.
typealias ResolverScopeUnique = ResolverScope

/// Proxy to container's scope. Cache type depends on type supplied to container (default .cache)
final class ResolverScopeContainer: ResolverScope {
    
    override init() {}
    
    override final func resolve<Service>(registration: ResolverRegistration<Service>, resolver: Resolver, args: Any?) -> Service? {
        return resolver.cache.resolve(registration: registration, resolver: resolver, args: args)
    }
    
}


#if os(iOS)
/// Storyboard Automatic Resolution Protocol
protocol StoryboardResolving: Resolving {
    func resolveViewController()
}

/// Storyboard Automatic Resolution Trigger
extension UIViewController {
    // swiftlint:disable unused_setter_value
    @objc dynamic var resolving: Bool {
        get {
            return true
        }
        set {
            if let vc = self as? StoryboardResolving {
                vc.resolveViewController()
            }
        }
    }
    // swiftlint:enable unused_setter_value
}
#endif

// Swift Property Wrappers

#if swift(>=5.1)
/// Immediate injection property wrapper.
///
/// Wrapped dependent service is resolved immediately using Resolver.root upon struct initialization.
///
@propertyWrapper struct Injected<Service> {
    private var service: Service
    init() {
        self.service = Resolver.resolve(Service.self)
    }
    init(name: Resolver.Name? = nil, container: Resolver? = nil) {
        self.service = container?.resolve(Service.self, name: name) ?? Resolver.resolve(Service.self, name: name)
    }
    var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    var projectedValue: Injected<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

/// OptionalInjected property wrapper.
///
/// If available, wrapped dependent service is resolved immediately using Resolver.root upon struct initialization.
///
@propertyWrapper struct OptionalInjected<Service> {
    private var service: Service?
    init() {
        self.service = Resolver.optional(Service.self)
    }
    init(name: Resolver.Name? = nil, container: Resolver? = nil) {
        self.service = container?.optional(Service.self, name: name) ?? Resolver.optional(Service.self, name: name)
    }
    var wrappedValue: Service? {
        get { return service }
        mutating set { service = newValue }
    }
    var projectedValue: OptionalInjected<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

/// Lazy injection property wrapper. Note that embedded container and name properties will be used if set prior to service instantiation.
///
/// Wrapped dependent service is not resolved until service is accessed.
///
@propertyWrapper struct LazyInjected<Service> {
    private var lock = Resolver.lock
    private var initialize: Bool = true
    private var service: Service!
    var container: Resolver?
    var name: Resolver.Name?
    var args: Any?
    init() {}
    init(name: Resolver.Name? = nil, container: Resolver? = nil) {
        self.name = name
        self.container = container
    }
    var isEmpty: Bool {
        lock.lock()
        defer { lock.unlock() }
        return service == nil
    }
    var wrappedValue: Service {
        mutating get {
            lock.lock()
            defer { lock.unlock() }
            if initialize {
                self.initialize = false
                self.service = container?.resolve(Service.self, name: name, args: args) ?? Resolver.resolve(Service.self, name: name, args: args)
            }
            return service
        }
        mutating set {
            lock.lock()
            defer { lock.unlock() }
            initialize = false
            service = newValue
        }
    }
    var projectedValue: LazyInjected<Service> {
        get { return self }
        mutating set { self = newValue }
    }
    mutating func release() {
        lock.lock()
        defer { lock.unlock() }
        self.service = nil
    }
}

/// Weak lazy injection property wrapper. Note that embedded container and name properties will be used if set prior to service instantiation.
///
/// Wrapped dependent service is not resolved until service is accessed.
///
@propertyWrapper struct WeakLazyInjected<Service> {
    private var lock = Resolver.lock
    private var initialize: Bool = true
    private weak var service: AnyObject?
    var container: Resolver?
    var name: Resolver.Name?
    var args: Any?
    init() {}
    init(name: Resolver.Name? = nil, container: Resolver? = nil) {
        self.name = name
        self.container = container
    }
    var isEmpty: Bool {
        lock.lock()
        defer { lock.unlock() }
        return service == nil
    }
    var wrappedValue: Service? {
        mutating get {
            lock.lock()
            defer { lock.unlock() }
            if initialize {
                self.initialize = false
                self.service = (container?.resolve(Service.self, name: name, args: args)
                                    ?? Resolver.resolve(Service.self, name: name, args: args)) as AnyObject
            }
            return service as? Service
        }
        mutating set {
            lock.lock()
            defer { lock.unlock() }
            initialize = false
            service = newValue as AnyObject
        }
    }
    var projectedValue: WeakLazyInjected<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
/// Immediate injection property wrapper for SwiftUI ObservableObjects. This wrapper is meant for use in SwiftUI Views and exposes
/// bindable objects similar to that of SwiftUI @observedObject and @environmentObject.
///
/// Dependent service must be of type ObservableObject. Updating object state will trigger view update.
///
/// Wrapped dependent service is resolved immediately using Resolver.root upon struct initialization.
///
@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper struct InjectedObject<Service>: DynamicProperty where Service: ObservableObject {
    @ObservedObject private var service: Service
    init() {
        self.service = Resolver.resolve(Service.self)
    }
    init(name: Resolver.Name? = nil, container: Resolver? = nil) {
        self.service = container?.resolve(Service.self, name: name) ?? Resolver.resolve(Service.self, name: name)
    }
    var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    var projectedValue: ObservedObject<Service>.Wrapper {
        return self.$service
    }
}
#endif
#endif
