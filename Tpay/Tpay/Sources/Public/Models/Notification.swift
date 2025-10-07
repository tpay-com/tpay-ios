//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation

/// Configuration for transaction notification
///
/// This struct allows you to specify how you want to receive notification about transaction status changes.
/// You can provide both a notification URL (for server-to-server communication) and an email address
/// for receiving transaction confirmation.

public struct Notification {

    // MARK: - Properties

    /// URL where Tpay will send HTTP notification about transaction status changes
    public let url: URL?

    /// Email address where transaction confirmation email will be sent
    public let email: String?

    // MARK: - Initializers

    /// Creates a new notification configuration
    ///
    /// - Parameters:
    ///   - url: Optional URL for HTTP notification
    ///   - email: Optional email address for email notification

    public init(url: URL? = nil, email: String? = nil) {
        self.url = url
        self.email = email
    }
}
