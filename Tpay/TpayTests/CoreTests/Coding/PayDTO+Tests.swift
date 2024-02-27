//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PayDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private lazy var jsonEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    
    // MARK: - Tests
    
    func test_RecursiveObjectEncoding() throws {
        let object = PayWithInstantRedirectionDTO.Recursive(period: .day, quantity: 1, expiryDate: Stub.date)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"expiryDate":0,"period":1,"quantity":1,"type":1}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_CardPaymentDataObjectEncoding_All() throws {
        let object = PayWithInstantRedirectionDTO.CardPaymentData(card: Stub.card, token: Stub.cardToken, shouldSave: true)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"card":"stubCard","save":true,"token":"stubCardToken"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_CardPaymentDataObjectEncoding_Required() throws {
        let object = PayWithInstantRedirectionDTO.CardPaymentData(card: nil, token: nil, shouldSave: false)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"save":false}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_BlikPaymentDataObjectEncoding_All() throws {
        let object = PayWithInstantRedirectionDTO.BlikPaymentData(blikToken: Stub.blikToken, aliases: Stub.blikAlias)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"aliases":{"key":"stubBlikAliasKey","label":"stubBlikAliasLabel","type":"UID","value":"stubBlikAliasValue"},"blikToken":"stubBlikToken"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_BlikPaymentDataObjectEncoding_Required() throws {
        let object = PayWithInstantRedirectionDTO.BlikPaymentData(blikToken: Stub.blikToken, aliases: nil)
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
        {"key":"stubBlikAliasKey","label":"stubBlikAliasLabel","type":"UID","value":"stubBlikAliasValue"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_AliasesObjectEncoding_Required() throws {
        let object = PayWithInstantRedirectionDTO.BlikPaymentData.Alias(value: Stub.blikAliasValue, type: .payId, label: nil, key: nil)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"type":"PAYID","value":"stubBlikAliasValue"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_PayObjectEncoding_All() throws {
        let object = PayWithInstantRedirectionDTO(channelId: .empty, method: .payByLink, blikPaymentData: Stub.blikPaymentData, cardPaymentData: Stub.cardPaymentData, recursive: Stub.recursive)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"blikPaymentData":{"aliases":{"key":"stubBlikAliasKey","label":"stubBlikAliasLabel","type":"UID","value":"stubBlikAliasValue"},"blikToken":"stubBlikToken"},"cardPaymentData":{"card":"stubCard","save":true,"token":"stubCardToken"},"channelId":-1,"method":"pay_by_link","recursive":{"expiryDate":0,"period":5,"quantity":100,"type":1}}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_PayObjectEncoding_Required() throws {
        let object = PayWithInstantRedirectionDTO(channelId: .empty, method: nil, blikPaymentData: nil, cardPaymentData: nil, recursive: nil)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"channelId":-1}
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
        
        static let blikAlias = PayWithInstantRedirectionDTO.BlikPaymentData.Alias(value: Stub.blikAliasValue, type: .uId, label: Stub.blikAliasLabel, key: Stub.blikAliasKey)
        static let blikPaymentData = PayWithInstantRedirectionDTO.BlikPaymentData(blikToken: Stub.blikToken, aliases: Stub.blikAlias)
        static let cardPaymentData = PayWithInstantRedirectionDTO.CardPaymentData(card: Stub.card, token: Stub.cardToken, shouldSave: true)
        
        static let recursive = PayWithInstantRedirectionDTO.Recursive(period: .year, quantity: 100, expiryDate: Stub.date)
    }
}
