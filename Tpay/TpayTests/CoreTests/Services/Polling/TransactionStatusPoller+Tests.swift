//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class TransactionStatusPoller_Tests: XCTestCase {
 
    // MARK: - Properties
    
    private lazy var networkingService: NetworkingService = {
        let credentialsProvider = MockCredentialsProvider()
        let authorizationHeadersProvider = DefaultAuthorizationHeadersProvider(with: credentialsProvider)
        let networkingProvider: NetworkingConfigurationManager = {
            let manager = DefaultNetworkingConfigurationManager()
            manager.store(configuration: Self.serviceConfiguration)
            return manager
        }()
        return NetworkingServiceFactory(configurationProvider: networkingProvider, authorizationHeadersProvider: authorizationHeadersProvider).make()
    }()
    private(set) lazy var sut = TransactionStatusPoller(for: "ta_zgLyJA7ELZaAGqvn", using: networkingService)
    
    private let disposer = Disposer()
    
    // MARK: - Tests
    
    func test_TransactionPolling() {
        let expectation = expectation(description: "transactionPolling")
        
        sut.result
            .subscribe(onNext: { result in
                debugPrint(result)
                expectation.fulfill()
            })
            .add(to: disposer)
        
        sut.startPolling(every: .seconds(3))
        
        waitForExpectations(timeout: 10)
    }
}

private extension TransactionStatusPoller_Tests {
    
    static let serviceConfiguration = NetworkingServiceConfiguration(scheme: "https", host: "api.tpay.com", port: nil)
}

private extension TransactionStatusPoller_Tests {
    
    final class MockCredentialsProvider: CredentialsProvider {
        
        // MARK: - Properties
        
        let claims: AuthorizationClaims? = AuthorizationClaims(accessToken: "")
        let credentials: AuthorizationCredentials? = AuthorizationCredentials(user: "client", password: "password")
    }
}
