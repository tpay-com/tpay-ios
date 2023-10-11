//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class DefaultRequestFactory_Tests: XCTestCase {
    
    // MARK: - Properties
    
    lazy var sut: RequestFactory = {
        let authorizationHeadersProvider = DefaultAuthorizationHeadersProvider(with: MockCredentialsProvider())
        let headersProvider = DefaultHeadersProvider(authorizationHeadersProvider: authorizationHeadersProvider)
        let networkingProvider: NetworkingConfigurationManager = {
            let manager = DefaultNetworkingConfigurationManager()
            manager.store(configuration: Self.serviceConfiguration)
            return manager
        }()
        
        let dateEncoder = DefaultDateEncoder(dateConverter: DefaultDateToServiceStringConverter())
        let jsonSerializer = DefaultJSONSerializer()
        let jsonEncoder = DefaultJSONEncoder(using: JSONEncoder(), dateEncoder: dateEncoder)
        let queryEncoder = DefaultQueryEncoder(using: jsonEncoder, jsonSerializer)
        let bodyEncoder = DefaultBodyEncoder(jsonEncoder: jsonEncoder)
        
        return DefaultRequestFactory(networkingConfigurationProvider: networkingProvider,
                                     headersProvider: headersProvider,
                                     queryEncoder: queryEncoder,
                                     bodyEncoder: bodyEncoder)
    }()
    
    // MARK: - Tests
    
    func test_MakeAuthorizeURLRequest() {
        let request = AuthorizationController.Authorize()
        let urlRequest = sut.request(for: request)
        
        expect(urlRequest.url?.absoluteString).to(equal("https://api.tpay.com/oauth/auth"))
        expect(urlRequest.httpMethod).to(equal(HttpMethod.post.rawValue))
        expect(urlRequest.allHTTPHeaderFields?["Authorization"]).to(equal("Basic Y2xpZW50OnBhc3N3b3Jk"))
        
        expect(urlRequest.httpBody).to(beNil())
    }
    
    func test_MakeBankGroupsURLRequest() {
        let request = TransactionsController.BankGroups()
        let urlRequest = sut.request(for: request)
        
        expect(urlRequest.url?.absoluteString).to(equal("https://api.tpay.com/transactions/bank-groups?onlyOnline=true"))
        expect(urlRequest.httpMethod).to(equal(HttpMethod.get.rawValue))
        expect(urlRequest.allHTTPHeaderFields?["Authorization"]).to(equal("Bearer access_token"))
        
        expect(urlRequest.httpBody).to(beNil())
    }
    
    func test_MakeSpecifiedTransactionURLRequest() {
        let transactionId = "transaction_id"
        let request = TransactionsController.SpecifiedTransaction(with: transactionId)
        let urlRequest = sut.request(for: request)
        
        expect(urlRequest.url?.absoluteString).to(equal("https://api.tpay.com/transactions/\(transactionId)"))
        expect(urlRequest.httpMethod).to(equal(HttpMethod.get.rawValue))
        expect(urlRequest.allHTTPHeaderFields?["Authorization"]).to(equal("Bearer access_token"))
        
        expect(urlRequest.httpBody).to(beNil())
    }
}

private extension DefaultRequestFactory_Tests {
    
    static let serviceConfiguration = NetworkingServiceConfiguration(scheme: "https", host: "api.tpay.com", port: nil)
}

private extension DefaultRequestFactory_Tests {
    
    final class MockCredentialsProvider: CredentialsProvider {
        
        // MARK: - Properties
        
        let claims: AuthorizationClaims? = AuthorizationClaims(accessToken: "access_token")
        let credentials: AuthorizationCredentials? = AuthorizationCredentials(user: "client", password: "password")
    }
}
