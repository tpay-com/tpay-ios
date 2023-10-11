//
//  Copyright © 2023 Tpay. All rights reserved.
//

import Foundation
import Nimble
@testable import Tpay
import XCTest

final class SecKey_Extensions_Tests: XCTestCase {
 
    func test_decodePublicKeyFromBase64() {
        expect(SecKey.decodePublicKey(from: Stub.rsaPublicKey)).notTo(beNil())
        expect(SecKey.decodePublicKey(from: "")).to(beNil())
    }
}

private extension SecKey_Extensions_Tests {
    
    enum Stub {
        
        // 2048-bit rsa public key generated via online tool.
        static let rsaPublicKey = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklUQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FRNEFNSUlCQ1FLQ0FRQnBCT2FaazdNdUwrT055NzBGNzlIMgo4dnUxVVdFYzRXUFhmd3BRQkxHNjBuWGNybnpNK2xWUnNHbXRmWW1zQm5NbmlZU3oyb0VYSkhoSW5ac1Q0K2tPCnpuZFhRNnhNd1JSdkhOOUJwM0UvTWxQTnlIVmpSaU50NzN4dm1JNDhmNWtIRUY2Z0trVzFodjFVazF1Znc1Y3MKcktGTDc4RHpBOWxQdmdmQkNvdjV0QmtrSDJ0Z1VkNGtyemk2OURidHBVYkJGOUhRYWdkTHlKd0pRYUs0R1k2UApEbHhuS2NOMW92ZWtHdWZVYmkxMUNBWUZ0UFVRQm9vYlo3b1dWTkM3T1pKUzg0Y2JNTWNUR0lQZ3V5UEQvdFhXCk1ucnFNRDVoODEyRTlJN2wyUDFiTmdaUGxMSG1ER1h0emZ4WncxY1J1UGlmOS9oTlRKUU5EZERuQjJXaFBPZjEKQWdNQkFBRT0KLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t"
    }
}
