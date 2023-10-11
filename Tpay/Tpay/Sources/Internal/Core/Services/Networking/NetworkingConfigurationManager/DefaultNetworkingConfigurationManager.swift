//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultNetworkingConfigurationManager: NetworkingConfigurationManager {
    
    // MARK: - Properties
    
    private(set) var configuration: NetworkingServiceConfiguration?
    
    // MARK: - API
    
    func store(configuration: NetworkingServiceConfiguration) {
        self.configuration = configuration
    }
    
    func remove() {
        configuration = nil
    }
}
