//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Configuration {
    
    enum Target {
        
        static func setup(as target: Tpay.Target) {
            Tpay.Target.current = target
        }
        
    }
    
}
