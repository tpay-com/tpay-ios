//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class NetworkingServiceFactory {
    
    // MARK: - Properties
    
    private let configurationProvider: NetworkingConfigurationProvider
    private let authorizationHeadersProvider: AuthorizationHeadersProvider
    
    // MARK: - Initializers
    
    convenience init(using resolver: ServiceResolver) {
        self.init(configurationProvider: resolver.resolve(),
                  authorizationHeadersProvider: resolver.resolve())
    }
    
    init(configurationProvider: NetworkingConfigurationProvider,
         authorizationHeadersProvider: AuthorizationHeadersProvider) {
        self.configurationProvider = configurationProvider
        self.authorizationHeadersProvider = authorizationHeadersProvider
    }
    
    // MARK: - API
    
    func make() -> NetworkingService {
        let jsonSerializer = DefaultJSONSerializer()
        let jsonEncoder = DefaultJSONEncoder(using: JSONEncoder(),
                                             dateEncoder: DefaultDateEncoder(dateConverter: DefaultDateToServiceStringConverter()))
        
        let queryEncoder = DefaultQueryEncoder(using: jsonEncoder, jsonSerializer)
        let bodyEncoder = DefaultBodyEncoder(jsonEncoder: jsonEncoder)
        
        let headersProvider = DefaultHeadersProvider(authorizationHeadersProvider: authorizationHeadersProvider)
        let requestFactory = DefaultRequestFactory(networkingConfigurationProvider: configurationProvider,
                                                   headersProvider: headersProvider,
                                                   queryEncoder: queryEncoder,
                                                   bodyEncoder: bodyEncoder)
        
        let jsonDecoder = DefaultJSONDecoder(using: JSONDecoder(), dateDecoder: DefaultDateDecoder(dateConverter: DefaultStringToDateConverter()))
        let bodyDecoder = DefaultBodyDecoder(using: jsonDecoder)
        
        let session = DefaultSession()
        let errorValidator = DefaultErrorValidator()
        let responseValidator = DefaultResponseValidator(using: jsonDecoder)
        
        return DefaultNetworkingService(requestFactory: requestFactory,
                                        session: session,
                                        errorValidator: errorValidator,
                                        responseValidator: responseValidator,
                                        bodyDecoder: bodyDecoder)
    }
    
}
