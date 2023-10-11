//
//  Copyright © 2022 Tpay. All rights reserved.
//

/// The `CertificatePinningConfiguration` struct represents a configuration for certificate pinning, a security mechanism that ensures secure communication between an app and a server by verifying the server's certificate against pre-defined public key hashes.
///
/// This configuration specifies the domain to which the pinning is applied and the array of public key hashes that the server's certificate must match.
/// - Important: Certificate pinning enhances security by mitigating the risks of man-in-the-middle attacks and ensuring the authenticity of the server.
/// - Warning: Ensure that the public key hashes are accurate and up-to-date, as incorrect hashes can lead to communication failures.

public struct CertificatePinningConfiguration {
    
    // MARK: - Properties
    
    let pinnedDomain: String = "api.tpay.com"
    let publicKeyHashes: [String]
    
    // MARK: - Initializers
    
    public init(publicKeyHashes: [String]) {
        self.publicKeyHashes = publicKeyHashes
    }
}
