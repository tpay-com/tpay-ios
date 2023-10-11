//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct ServiceError: Decodable, Equatable {
    
    // MARK: - Properties
    
    let errorCode: String?
    let errorMessage: String?
    let fieldName: String?
    let devMessage: String?
    let docUrl: String?
}
