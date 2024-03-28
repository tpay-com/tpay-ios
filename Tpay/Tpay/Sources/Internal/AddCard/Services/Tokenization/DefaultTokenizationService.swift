//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultTokenizationService: TokenizationService {
    
    // MARK: - Properties
    
    private let networkingService: NetworkingService
    private let encryptor: CardEncryptor
    private let merchant: Merchant
    private let callbacksConfiguration: CallbacksConfiguration
    private let mapper: TransportationToDomainModelsMapper
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        let configurationProvider: ConfigurationProvider = resolver.resolve()
        guard let merchant = configurationProvider.merchant else {
            preconditionFailure("Merchant is not configured")
        }
        self.init(networkingService: resolver.resolve(),
                  encryptor: DefaultCardEncryptor(using: resolver),
                  merchant: merchant,
                  mapper: DefaultTransportationToDomainModelsMapper(),
                  callbacksConfiguration: configurationProvider.callbacksConfiguration)
    }
    
    init(networkingService: NetworkingService,
         encryptor: CardEncryptor,
         merchant: Merchant,
         mapper: TransportationToDomainModelsMapper,
         callbacksConfiguration: CallbacksConfiguration) {
        self.networkingService = networkingService
        self.encryptor = encryptor
        self.merchant = merchant
        self.mapper = mapper
        self.callbacksConfiguration = callbacksConfiguration
    }
    
    // MARK: - API
    
    func tokenize(_ card: Domain.Card, payer: Domain.Payer, then: @escaping (Result<Domain.OngoingTokenization, Error>) -> Void) {
        guard let dto = try? makeNewCardDTO(from: card, payer: payer) else {
            then(.failure(TokenizationError.cannotMakeNewCardDTO))
            return
        }
        let request = TokenizationController.NewCard(dto: dto)
        networkingService.execute(request: request)
            .onSuccess { [weak self] response in
                guard let self = self else { return }
                then(.success(self.mapper.makeOngoingTokenization(from: response)))
            }
            .onError { error in then(.failure(error)) }
    }
    
    // MARK: - Private
    
    private func makeNewCardDTO(from card: Domain.Card, payer: Domain.Payer) throws -> NewCardDTO {
        let encrypted = try encryptor.encrypt(card: card).data.base64EncodedString()
        return NewCardDTO(payer: makePayerDTO(from: payer),
                          callback: callbacksConfiguration.notificationsUrl ?? .init(safeString: merchant.domain),
                          redirect: makeRedirects(),
                          card: encrypted)
    }
    
    private func makePayerDTO(from payer: Domain.Payer) -> PayerDTO {
        .init(email: payer.email,
              name: payer.name,
              phone: payer.phone,
              address: payer.address?.address,
              postalCode: payer.address?.postalCode,
              city: payer.address?.city,
              country: payer.address?.country)
    }
    
    private func makeRedirects() -> NewCardDTO.Redirects {
        .init(successUrl: callbacksConfiguration.successRedirectUrl,
              errorURL: callbacksConfiguration.errorRedirectUrl)
    }
}
