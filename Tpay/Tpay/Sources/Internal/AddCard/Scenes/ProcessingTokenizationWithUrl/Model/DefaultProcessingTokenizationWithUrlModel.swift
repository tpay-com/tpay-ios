//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultProcessingTokenizationWithUrlModel: ProcessingTokenizationWithUrlModel {
    
    // MARK: - Properties
    
    let continueUrl: URL
    let successUrl: URL
    let errorUrl: URL
    
    // MARK: - Initializers
    
    init(tokenization: Domain.OngoingTokenization, resolver: ServiceResolver) {
        guard let continueUrl = tokenization.continueUrl else { preconditionFailure("Continue url should be available here") }
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchant = configurationProvider.merchant else { preconditionFailure("Merchant is not configured") }
        
        self.continueUrl = continueUrl
        self.successUrl = merchant.successCallbackUrl
        self.errorUrl = merchant.errorCallbackUrl
    }
}
