//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct NetworkingServiceConfiguration {
    
    // MARK: - Properties
    
    let scheme: String
    let host: String
    let port: Int?
    
    // MARK: - Initializers
    
    init(scheme: String, host: String, port: Int? = nil) {
        self.scheme = scheme
        self.host = host
        self.port = port
    }
}
