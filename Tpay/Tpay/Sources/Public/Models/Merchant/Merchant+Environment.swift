//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Merchant {
    
    public enum Environment: CaseIterable, Equatable, Codable {
        
        // MARK: - Cases
        
        case production
        case sandbox
    }
}
