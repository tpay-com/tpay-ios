//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultNetworkingService_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var sut: NetworkingService = {
        let credentialsProvider = MockCredentialsProvider()
        let authorizationHeadersProvider = DefaultAuthorizationHeadersProvider(with: credentialsProvider)
        let networkingProvider: NetworkingConfigurationManager = {
            let manager = DefaultNetworkingConfigurationManager()
            manager.store(configuration: Self.serviceConfiguration)
            return manager
        }()
        let sdkConfigurationProvider = MockConfigurationProvider()
        return NetworkingServiceFactory(configurationProvider: networkingProvider, authorizationHeadersProvider: authorizationHeadersProvider, sdkConfigurationProvider: sdkConfigurationProvider).make()
    }()
 
    // MARK: - Tests
    
    func test_Authorize() {
        let request = AuthorizationController.Authorize()
        let expectation = expectation(description: "authorize")
        
        sut.execute(request: request)
            .onSuccess { object in debugPrint(object) }
            .onError { error in debugPrint(error) }
            .onResult { _ in expectation.fulfill() }
        
        waitForExpectations(timeout: 3.0)
    }
    
    func test_GetSpecifiedTransaction() {
        let request = TransactionsController.SpecifiedTransaction(with: "ta_zgLyJA7ELZaAGqvn")
        let expectation = expectation(description: "getSpecifiedTransaction")
        
        sut.execute(request: request)
            .onSuccess { object in debugPrint(object) }
            .onError { error in debugPrint(error) }
            .onResult { _ in expectation.fulfill() }
        
        waitForExpectations(timeout: 3.0)
    }
}

private extension DefaultNetworkingService_Tests {
    
    static let serviceConfiguration = NetworkingServiceConfiguration(scheme: "https", host: "api.tpay.com", port: nil)
}

private extension DefaultNetworkingService_Tests {

    final class MockCredentialsProvider: CredentialsProvider {

        // MARK: - Properties

        let claims: AuthorizationClaims? = AuthorizationClaims(accessToken: "")
        let credentials: AuthorizationCredentials? = AuthorizationCredentials(user: "client", password: "password")
    }

    final class MockConfigurationProvider: ConfigurationProvider {

        // MARK: - Properties

        var merchant: Merchant?
        var callbacksConfiguration: CallbacksConfiguration = .default
        var merchantDetailsProvider: MerchantDetailsProvider?
        var paymentMethods: [PaymentMethod] = PaymentMethod.allCases
        var preferredLanguage: Language = .en
        var supportedLanguages: [Language] = Language.allCases
        var compatibility: Tpay.Compatibility = .ios
        var sdkVersionName: String? = "1.0.0"
    }
}
