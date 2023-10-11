//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol NetworkingConfigurationProvider: AnyObject {
    
    // MARK: - Properties
    
    var configuration: NetworkingServiceConfiguration? { get }
}
