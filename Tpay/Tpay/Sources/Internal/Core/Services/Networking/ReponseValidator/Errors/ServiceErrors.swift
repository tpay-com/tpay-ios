//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct ServiceErrors: Decodable, Equatable {
    
    // MARK: - Properties
    
    let errors: [ServiceError]
}
