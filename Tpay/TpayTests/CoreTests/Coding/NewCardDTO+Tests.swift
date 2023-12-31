//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class NewCardDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    let jsonEncoder = JSONEncoder()
    
    // MARK: - Tests
    
    func test_NewTransactionObjectEncoding_All() throws {
        let object = NewCardDTO(payer: Stub.payer,
                                callback: Stub.callback,
                                redirect: Stub.redirect,
                                card: Stub.card)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"redirectUrl":{"success":"https:\\/\\/stub.com\\/success","error":"https:\\/\\/stub.com\\/error"},"callbackUrl":"https:\\/\\/stub.com","card":"stubCard","payer":{"email":"stubEmail","name":"stubName"}}
        """
        
        expect(sut) == expectedPayload
    }
}

private extension NewCardDTO_Tests {
    
    enum Stub {
        static let payer = PayerDTO(email: "stubEmail", name: "stubName", phone: nil, address: nil, postalCode: nil, city: nil, country: nil)
        static let callback = "https://stub.com"
        static let redirect = NewCardDTO.Redirects(successUrl: .init(safeString: "https://stub.com/success"),
                                                   errorURL: .init(safeString: "https://stub.com/error"))
        static let card = "stubCard"
    }
}
