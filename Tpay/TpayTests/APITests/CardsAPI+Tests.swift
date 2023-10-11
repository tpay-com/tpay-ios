//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class CardsAPI_Tests: XCTestCase {
 
    // MARK: - Tests
    
    func test_Init() {
        expect(try Merchant.CardsAPI(publicKey: Stub.rsaPublicKey)).notTo(throwError())
        expect(try Merchant.CardsAPI(publicKey: "")).to(throwError())
    }
}

private extension CardsAPI_Tests {
    
    enum Stub {
        
        // 2048-bit rsa public key generated via online tool.
        static let rsaPublicKey = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUEwVFV3a3diTDRKNm0zRFhoZVVBbQpKWTVQM1VLcTc3bFRER2Y0UUN5bklINmRMVjV6aEdETGNSRDVISURWWEErOS9NRy8xTFVXYmJmMUtYL2NzVzFoClhlN3BHd0NWZThYWDF5Yys3eGgxL1U4cXM3YnlDZTZGMGVSank4WmlrZUc4cGlEK0ppdGhmZTRYNWNFYTlHbHMKS25iTVUxK3c4a3lkV3N2MVNPRkdLZnNwN2RyVUF2em1sOHdKUWtZUVQyNC9nUFRnRDUxZnFLL05CTEdUK3ZwUgpHYy9IT0NnSGUvVFhjem5sR1FDd3RaSXFGQkhocy8rTmlUR0M4OGRqbG85RzBwNGdEKzRpcVE3S3U1RzMyMnJpClpWRndqZ2FBdHFLN0t5cENaTm9ndnZmZW5RMzQ3TG9sbWhaVjR1RDlqMG5QYUgxVzRHeEZybEMyYkFPYndLK1oKcFFJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t"
    }
}
