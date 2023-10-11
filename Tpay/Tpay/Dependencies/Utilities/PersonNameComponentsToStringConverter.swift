//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Converter allows map PersonNameComponents input into string representation
protocol PersonNameComponentsToStringConverter: AnyObject {
    
    /// Create formatted string from given input
    /// - Parameter components:
    func string(from components: PersonNameComponents) -> String?
    
}
