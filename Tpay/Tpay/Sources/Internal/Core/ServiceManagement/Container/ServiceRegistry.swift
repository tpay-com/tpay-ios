//
//  Copyright © 2022 Tpay. All rights reserved.
//

typealias RegistryFactory<Service> = () -> Service?
typealias RegistryFactoryResolver<Service> = (_ resolver: ServiceResolver) -> Service?
typealias RegistryFactoryArguments<Service> = (_ resolver: ServiceResolver, _ args: Any?) -> Service?

protocol ServiceRegistry {
    
    @discardableResult
    func register<Service>(_ type: Service.Type, name: String?, factory: @escaping RegistryFactory<Service>) -> ServiceEntry<Service>

    @discardableResult
    func register<Service>(_ type: Service.Type, name: String?, factory: @escaping RegistryFactoryResolver<Service>) -> ServiceEntry<Service>

    @discardableResult
    func register<Service>(_ type: Service.Type, name: String?, factory: @escaping RegistryFactoryArguments<Service>) -> ServiceEntry<Service>

    func reset()
}
