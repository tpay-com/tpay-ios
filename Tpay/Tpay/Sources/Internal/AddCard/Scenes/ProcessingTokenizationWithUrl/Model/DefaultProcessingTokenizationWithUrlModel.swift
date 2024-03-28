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
        
        self.continueUrl = continueUrl
        self.successUrl = configurationProvider.callbacksConfiguration.successRedirectUrl
        self.errorUrl = configurationProvider.callbacksConfiguration.errorRedirectUrl
    }
}
