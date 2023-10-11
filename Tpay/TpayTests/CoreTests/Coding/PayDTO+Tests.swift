//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PayDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    let jsonEncoder = JSONEncoder()
    
    // MARK: - Tests
    
    func test_RecursiveObjectEncoding() throws {
        let object = PayDTO.Recursive(period: .day, quantity: 1, expiryDate: Stub.date)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"quantity":1,"expiryDate":0,"type":1,"period":1}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_CardPaymentDataObjectEncoding_All() throws {
        let object = PayDTO.CardPaymentData(card: Stub.card, token: Stub.cardToken, shouldSave: true)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"token":"stubCardToken","card":"stubCard","save":true}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_CardPaymentDataObjectEncoding_Required() throws {
        let object = PayDTO.CardPaymentData(card: nil, token: nil, shouldSave: false)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"save":false}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_BlikPaymentDataObjectEncoding_All() throws {
        let object = PayDTO.BlikPaymentData(blikToken: Stub.blikToken, aliases: Stub.blikAlias)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"aliases":{"value":"stubBlikAliasValue","label":"stubBlikAliasLabel","key":"stubBlikAliasKey","type":"UID"},"blikToken":"stubBlikToken"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_BlikPaymentDataObjectEncoding_Required() throws {
        let object = PayDTO.BlikPaymentData(blikToken: Stub.blikToken, aliases: nil)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"blikToken":"stubBlikToken"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_AliasesObjectEncoding_All() throws {
        let object = Stub.blikAlias
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"value":"stubBlikAliasValue","label":"stubBlikAliasLabel","key":"stubBlikAliasKey","type":"UID"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_AliasesObjectEncoding_Required() throws {
        let object = PayDTO.BlikPaymentData.Alias(value: Stub.blikAliasValue, type: .payId, label: nil, key: nil)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"value":"stubBlikAliasValue","type":"PAYID"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_PayObjectEncoding_All() throws {
        let object = PayDTO(groupId: .unknown, method: .payByLink, blikPaymentData: Stub.blikPaymentData, cardPaymentData: Stub.cardPaymentData, recursive: Stub.recursive)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"groupId":-1,"recursive":{"quantity":100,"expiryDate":0,"type":1,"period":5},"method":"pay_by_link","blikPaymentData":{"aliases":{"value":"stubBlikAliasValue","label":"stubBlikAliasLabel","key":"stubBlikAliasKey","type":"UID"},"blikToken":"stubBlikToken"},"cardPaymentData":{"token":"stubCardToken","card":"stubCard","save":true}}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_PayObjectEncoding_Required() throws {
        let object = PayDTO(groupId: .unknown, method: nil, blikPaymentData: nil, cardPaymentData: nil, recursive: nil)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"groupId":-1}
        """
        
        expect(sut) == expectedPayload
    }
}

private extension PayDTO_Tests {
    
    enum Stub {
        static let date = Date(timeIntervalSinceReferenceDate: 0)
        
        static let card = "stubCard"
        static let cardToken = "stubCardToken"
        
        static let blikToken = "stubBlikToken"
        
        static let blikAliasValue = "stubBlikAliasValue"
        static let blikAliasLabel = "stubBlikAliasLabel"
        static let blikAliasKey = "stubBlikAliasKey"
        
        static let blikAlias = PayDTO.BlikPaymentData.Alias(value: Stub.blikAliasValue, type: .uId, label: Stub.blikAliasLabel, key: Stub.blikAliasKey)
        static let blikPaymentData = PayDTO.BlikPaymentData(blikToken: Stub.blikToken, aliases: Stub.blikAlias)
        static let cardPaymentData = PayDTO.CardPaymentData(card: Stub.card, token: Stub.cardToken, shouldSave: true)
        
        static let recursive = PayDTO.Recursive(period: .year, quantity: 100, expiryDate: Stub.date)
    }
}
