//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class NewTransactionDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var jsonEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    
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
        {"amount":4.2,"callbacks":{"notification":{"url":null},"payerUrls":{"error":"https:\\/\\/stub.com\\/error","success":"https:\\/\\/stub.com\\/success"}},"description":"stubDescription","hiddenDescription":"stubHiddenDescription","lang":"pl","pay":{"channelId":-1},"payer":{"email":"stubEmail","name":"stubName"}}
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
        {"amount":4.2,"callbacks":{"notification":{"url":null},"payerUrls":{"error":"https:\\/\\/stub.com\\/error","success":"https:\\/\\/stub.com\\/success"}},"pay":{"channelId":-1},"payer":{"email":"stubEmail","name":"stubName"}}
        """
        
        expect(sut) == expectedPayload
    }
}

private extension NewTransactionDTO_Tests {
    
    enum Stub {
        static let amount = Decimal(4.20)
        static let description = "stubDescription"
        static let hiddenDescription = "stubHiddenDescription"
        static let pay = PayWithInstantRedirectionDTO(channelId: .empty, method: nil, blikPaymentData: nil, cardPaymentData: nil, recursive: nil)
        static let payer = PayerDTO(email: "stubEmail", name: "stubName", phone: nil, address: nil, postalCode: nil, city: nil, country: nil)
        static let callbacks = NewTransactionDTO.Callbacks(successUrl: .init(safeString: "https://stub.com/success"),
                                                           errorUrl: .init(safeString: "https://stub.com/error"),
                                                           notificationUrl: nil,
                                                           notificationEmail: nil)
    }
}
