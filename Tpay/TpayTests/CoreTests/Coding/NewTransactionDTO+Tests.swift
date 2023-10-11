//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class NewTransactionDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    let jsonEncoder = JSONEncoder()
    
    // MARK: - Tests
    
    func test_NewTransactionObjectEncoding_All() throws {
        let object = NewTransactionDTO(amount: Stub.amount,
                                       description: Stub.description,
                                       hiddenDescription: Stub.hiddenDescription,
                                       language: .pl,
                                       pay: Stub.pay,
                                       payer: Stub.payer,
                                       callbacks: Stub.callbacks)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"amount":4.2,"pay":{"groupId":-1},"lang":"pl","hiddenDescription":"stubHiddenDescription","description":"stubDescription","payer":{"email":"stubEmail","name":"stubName"},"callbacks":{"payerUrls":{"success":"https:\\/\\/stub.com\\/success","error":"https:\\/\\/stub.com\\/error"}}}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_NewTransactionObjectEncoding_Required() throws {
        let object = NewTransactionDTO(amount: Stub.amount,
                                       description: nil,
                                       hiddenDescription: nil,
                                       language: nil,
                                       pay: Stub.pay,
                                       payer: Stub.payer,
                                       callbacks: Stub.callbacks)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"amount":4.2,"pay":{"groupId":-1},"callbacks":{"payerUrls":{"success":"https:\\/\\/stub.com\\/success","error":"https:\\/\\/stub.com\\/error"}},"payer":{"email":"stubEmail","name":"stubName"}}
        """
        
        expect(sut) == expectedPayload
    }
}

private extension NewTransactionDTO_Tests {
    
    enum Stub {
        static let amount = Decimal(4.20)
        static let description = "stubDescription"
        static let hiddenDescription = "stubHiddenDescription"
        static let pay = PayDTO(groupId: .unknown, method: nil, blikPaymentData: nil, cardPaymentData: nil, recursive: nil)
        static let payer = PayerDTO(email: "stubEmail", name: "stubName", phone: nil, address: nil, postalCode: nil, city: nil, country: nil)
        static let callbacks = NewTransactionDTO.Callbacks(successUrl: .init(safeString: "https://stub.com/success"),
                                                           errorURL: .init(safeString: "https://stub.com/error"))
    }
}
