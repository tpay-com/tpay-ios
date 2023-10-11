//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

final class DefaultPersonNameComponentsToStringConverter: PersonNameComponentsToStringConverter {
    
    // MARK: - Properties
    
    private let formatter = PersonNameComponentsFormatter()
    
    // MARK: - API
    
    func string(from components: PersonNameComponents) -> String? {
        guard components.givenName != nil, components.familyName != nil else { return .none }
        return formatter.string(from: components)
    }
    
}
