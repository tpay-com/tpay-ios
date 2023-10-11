//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultErrorValidator: ErrorValidator {
    
    // MARK: - API
    
    func validate(error: Error?) throws {
        if let error = error {
            throw NetworkingError(with: error) ?? error
        }
    }
}
