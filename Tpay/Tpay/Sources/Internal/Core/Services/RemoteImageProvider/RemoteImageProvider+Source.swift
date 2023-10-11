//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension RemoteImageProvider {
    
    enum Source {
        
        // MARK: - Cases
        
        case network
        case memory
        case disk
        
        // MARK: - Initializers
        
        init(wrapping cacheType: CacheType) {
            switch cacheType {
            case .disk: self = .disk
            case .memory: self = .memory
            case .none: self = .network
            }
        }
    }
}
