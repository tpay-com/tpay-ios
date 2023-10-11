//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ServiceResolver {
    
    func resolve<Service>() -> Service
    func resolve<Service>(_ type: Service.Type, name: String?, args: Any?) -> Service
    func optional<Service>() -> Service?
    func optional<Service>(_ type: Service.Type, name: String?, args: Any?) -> Service?
}
