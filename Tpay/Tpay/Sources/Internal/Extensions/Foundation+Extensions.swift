//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension String {
    
    func removeWhitespacesAndNewlines() -> Self {
        replacingOccurrences(of: " ", with: "")
    }
    
    func removeDashes() -> Self {
        replacingOccurrences(of: "-", with: "")
    }
}
