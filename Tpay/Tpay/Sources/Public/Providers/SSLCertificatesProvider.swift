//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `SSLCertificatesProvider` protocol defines the properties required to provide SSL certificate-related configurations.

public protocol SSLCertificatesProvider {
    
    // MARK: - Properties
    
    /// The SSL certificate pinning configuration for securing communication with the tpay API.
    
    var apiConfiguration: CertificatePinningConfiguration { get }
}
