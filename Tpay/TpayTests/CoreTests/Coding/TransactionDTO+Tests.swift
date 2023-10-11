//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class TransactionDTO_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Tests
    
    func test_PendingTransactionDecoding() throws {
        let payload =
        """
        {
            "result": "success",
            "requestId": "9e5e89467428b8247a44",
            "transactionId": "ta_zgLyJA7ELZaAGqvn",
            "title": "TR-2C3F-63T26GX",
            "posId": "ps_Bd2n9JwggXoJepM6",
            "status": "pending",
            "date": {
                "creation": "2022-05-11 17:14:18",
                "realization": null
            },
            "amount": 4.2,
            "currency": "PLN",
            "description": "Zakupy",
            "hiddenDescription": "",
            "lock": {
                "type": null,
                "status": null,
                "amount": null,
                "amountCollected": null
            }
        }
        """
        
        let sut = try jsonDecoder.decode(TransactionDTO.self, from: try XCTUnwrap(payload.data(using: .utf8)))
        
        expect(sut.result).to(equal(.success))
        expect(sut.requestId).to(equal("9e5e89467428b8247a44"))
        
        expect(sut.title).to(equal("TR-2C3F-63T26GX"))
        expect(sut.posId).to(equal("ps_Bd2n9JwggXoJepM6"))
        expect(sut.status).to(equal(.pending))
        
        expect(sut.dates.creation).to(equal("2022-05-11 17:14:18"))
        expect(sut.dates.realization).to(beNil())
        
        expect(sut.amount).to(equal(4.20))
        expect(sut.currency).to(equal(.PLN))
        
        expect(sut.description).to(equal("Zakupy"))
        expect(sut.hiddenDescription).to(beEmpty())
    }
}
