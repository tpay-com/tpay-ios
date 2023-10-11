//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PayerContext_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_GetTokenizedCards_OnlyTokens() {
        let sut = PayerContext(automaticPaymentMethods: Stub.onlyCardTokens)
        
        expect(sut.hasTokenizedCards).to(beTrue())
        expect(sut.tokenizedCards.count) == 3
    }
    
    func test_GetTokenizedCards_Mixed() {
        let sut = PayerContext(automaticPaymentMethods: Stub.mixed)
        
        expect(sut.hasTokenizedCards).to(beTrue())
        expect(sut.tokenizedCards.count) == 3
    }
    
    func test_GetTokenizedCards_Empty() {
        let sut = PayerContext()
        
        expect(sut.hasTokenizedCards).to(beFalse())
        expect(sut.tokenizedCards.isEmpty).to(beTrue())
    }
    
    func test_GetBlikAliases_OnlyAliases() {
        let sut = PayerContext(automaticPaymentMethods: Stub.onlyBlikAlias)
        
        expect(sut.hasRegisteredBlikAlias).to(beTrue())
    }
    
    func test_GetBlikAliases_Mixed() {
        let sut = PayerContext(automaticPaymentMethods: Stub.mixed)
        
        expect(sut.hasRegisteredBlikAlias).to(beTrue())
    }
    
    func test_GetBlikAliases_Empty() {
        let sut = PayerContext()
        
        expect(sut.hasRegisteredBlikAlias).to(beFalse())
    }
}

// swiftlint:disable force_try
private extension PayerContext_Extensions_Tests {
    
    enum Stub {
        static let blikAlias: RegisteredBlikAlias = .init(value: .uid("alias"))
        static let tokenizedCards: [CardToken] = [try! .init(token: "token1", cardTail: "1234", brand: .mastercard),
                                                  try! .init(token: "token2", cardTail: "1234", brand: .mastercard),
                                                  try! .init(token: "token3", cardTail: "1234", brand: .mastercard)]
        
        static let onlyCardTokens: AutomaticPaymentMethods = .init(tokenizedCards: Stub.tokenizedCards)
        static let onlyBlikAlias: AutomaticPaymentMethods = .init(registeredBlikAlias: Stub.blikAlias, tokenizedCards: nil)
        static let mixed: AutomaticPaymentMethods = .init(registeredBlikAlias: Stub.blikAlias, tokenizedCards: Stub.tokenizedCards)
    }
}
