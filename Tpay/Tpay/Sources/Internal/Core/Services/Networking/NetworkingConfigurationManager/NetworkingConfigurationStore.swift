//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol NetworkingConfigurationStore: AnyObject {
    
    // MARK: - API
    
    func store(configuration: NetworkingServiceConfiguration)
    func remove()
}
