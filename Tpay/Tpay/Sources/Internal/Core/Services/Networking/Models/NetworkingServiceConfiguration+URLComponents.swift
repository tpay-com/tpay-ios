//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension NetworkingServiceConfiguration {
    
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        return components
    }
}
