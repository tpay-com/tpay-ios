//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct InputValidationError: Hashable {
    
    // MARK: - Properties
    
    let description: String
    
    // MARK: - Initializers
    
    init(description: String) {
        self.description = description
    }
}
