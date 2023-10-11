//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultAddCardModel: AddCardModel {
    
    // MARK: - Properties
    
    let payer: Payer?
    let merchantDetails: Domain.MerchantDetails
    
    private let authenticationService: AuthenticationService
    private let tokenizationService: TokenizationService
    
    // MARK: - Initialization
    
    convenience init(with payer: Payer?, using resolver: ServiceResolver) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchantDetailsProvider = configurationProvider.merchantDetailsProvider else {
            preconditionFailure("Merchant details is not configured")
        }
        self.init(payer: payer,
                  authenticationService: DefaultAuthenticationService(resolver: resolver),
                  tokenizationService: DefaultTokenizationService(using: resolver),
                  merchantDetailsProvider: merchantDetailsProvider)
    }
    
    init(payer: Payer?,
         authenticationService: AuthenticationService,
         tokenizationService: TokenizationService,
         merchantDetailsProvider: MerchantDetailsProvider) {
        self.payer = payer
        self.authenticationService = authenticationService
        self.tokenizationService = tokenizationService
        self.merchantDetails = Domain.MerchantDetails(displayName: merchantDetailsProvider.merchantDisplayName(for: .current),
                                                      headquarters: merchantDetailsProvider.merchantHeadquarters(for: .current),
                                                      regulationsUrl: merchantDetailsProvider.regulationsLink(for: .current))
    }
    
    // MARK: - API
    
    func tokenize(_ card: Domain.Card, payer: Domain.Payer, then: @escaping (Result<Domain.OngoingTokenization, Error>) -> Void) {
        Invocation.Queue()
            .append(authenticationService.authenticate)
            .invoke(completion: { [weak self] result in
                switch result {
                case .success:
                    self?.tokenizationService.tokenize(card, payer: payer, then: then)
                case .failure(let error):
                    then(.failure(error))
                }
            })
    }
}
