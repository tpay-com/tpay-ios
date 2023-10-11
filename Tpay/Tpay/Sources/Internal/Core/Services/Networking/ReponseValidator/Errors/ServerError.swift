//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct ServerError: Equatable {
    
    // MARK: - Properties
    
    let httpStatusCode: HttpStatusCode
    let errors: ServiceErrors
}
