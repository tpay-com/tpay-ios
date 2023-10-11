//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class PayerDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    let jsonEncoder = JSONEncoder()
    
    // MARK: - Tests
    
    func test_PayerObjectEncoding_All() throws {
        let object = PayerDTO(email: Stub.email, name: Stub.name, phone: Stub.phone, address: Stub.address, postalCode: Stub.postalCode, city: Stub.city, country: Stub.country)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"phone":"stubPhone","city":"stubCity","country":"stubCountry","address":"stubAddress","code":"stubPostalCode","email":"stubEmail","name":"stubName"}
        """
        
        expect(sut) == expectedPayload
    }
    
    func test_PayerObjectEncoding_Required() throws {
        let object = PayerDTO(email: Stub.email, name: Stub.name, phone: nil, address: nil, postalCode: nil, city: nil, country: nil)
        let sut = String(data: try jsonEncoder.encode(object), encoding: .utf8)
        let expectedPayload =
        """
        {"email":"stubEmail","name":"stubName"}
        """
        
        expect(sut) == expectedPayload
    }
}

private extension PayerDTO_Tests {
    
    enum Stub {
        static let email = "stubEmail"
        static let name = "stubName"

        static let phone = "stubPhone"
        static let address = "stubAddress"
        static let postalCode = "stubPostalCode"
        static let city = "stubCity"
        static let country = "stubCountry"
    }
}
