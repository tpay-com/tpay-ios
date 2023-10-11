//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension ResponseDTO {
    
    enum Result: String, Decodable {

        // MARK: - Cases
    
        case success
        case actionRequired
        case pending
        case failed
    }
}
