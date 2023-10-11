//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// A type that provides merchant-specific information displayed across module screens.
///
/// - Note: Conforming types should provide accurate and localized information for each method.

public protocol MerchantDetailsProvider {
    
    // MARK: - API
    
    /// Retrieves the merchant's display name based on the specified language.
    /// - Parameter language: The language for which the display name is requested.
    /// - Returns: The localized display name of the merchant.
    
    func merchantDisplayName(for language: Language) -> String
    
    /// Retrieves the merchant's headquarters location based on the specified language.
    /// - Parameter language: The language for which the headquarters location is requested.
    /// - Returns: The localized headquarters location of the merchant, or nil if not available.
    
    func merchantHeadquarters(for language: Language) -> String?
    
    /// Retrieves the URL link to regulations based on the specified language.
    /// - Parameter language: The language for which the regulations link is requested.
    /// - Returns: The localized URL link to regulations.
    
    func regulationsLink(for language: Language) -> URL
}
