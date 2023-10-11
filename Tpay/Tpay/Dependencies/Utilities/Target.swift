//
//  Copyright © 2022 Tpay. All rights reserved.
//

enum Target {
    
    // MARK: - Properties
    
   static var current: Target = .production
    
    // MARK: - Cases
    
    case develop
    case test
    case uat
    
    case production
    
}
