//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultAuthenticationService: AuthenticationService {
    
    // MARK: - Properties
    
    private let networkingService: NetworkingService
    private let credentialsStore: CredentialsStore
    
    // MARK: - Initializers
    
    convenience init(resolver: ServiceResolver) {
        self.init(using: resolver.resolve(), credentialsStore: resolver.resolve())
    }
    
    init(using networkingService: NetworkingService, credentialsStore: CredentialsStore) {
        self.networkingService = networkingService
        self.credentialsStore = credentialsStore
    }
    
    // MARK: - API
    
    func authenticate(then: @escaping Completion) {
        let request = AuthorizationController.Authorize()
        networkingService.execute(request: request)
            .onSuccess { [weak self] response in
                guard let self = self else { return }
                self.store(claims: self.makeAuthorizationClaims(from: response))
                then(.success(()))
            }
            .onError { error in then(.failure(error)) }
    }
    
    // MARK: - Private
    
    private func store(claims: AuthorizationClaims) {
        credentialsStore.store(claims: claims)
    }
    
    private func makeAuthorizationClaims(from authorizeResponse: AuthorizationController.Authorize.Response) -> AuthorizationClaims {
        AuthorizationClaims(accessToken: authorizeResponse.accessToken)
    }
}
