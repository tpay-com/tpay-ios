//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

public struct CallbacksConfiguration {
    
    // MARK: - Properties
    
    let successRedirectUrl: URL
    let errorRedirectUrl: URL
    let notificationsUrl: URL?
    
    // MARK: - Initializers
    
    public init(successRedirectUrl: URL? = nil,
                errorRedirectUrl: URL? = nil,
                notificationsUrl: URL? = nil) {
        self.successRedirectUrl = successRedirectUrl ?? Defaults.successRedirectUrl
        self.errorRedirectUrl = errorRedirectUrl ?? Defaults.errorRedirectUrl
        self.notificationsUrl = notificationsUrl
    }
}

extension CallbacksConfiguration {
    
    static let `default` = CallbacksConfiguration()
    
    enum Defaults {
        
        static let successRedirectUrl = URL(safeString: "https://secure.tpay.com/mobile-sdk/success/")
        static let errorRedirectUrl = URL(safeString: "https://secure.tpay.com/mobile-sdk/error/")
    }
}
