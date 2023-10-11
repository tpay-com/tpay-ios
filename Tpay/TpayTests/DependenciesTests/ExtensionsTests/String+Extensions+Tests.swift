//
//  Copyright © 2022 Tpay. All rights reserved.
//

@testable import Tpay
import Nimble
import XCTest

final class String_Extensions_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_IsNotEmpty() {
        let emptyString = ""
        expect(emptyString.isNotEmpty).to(beFalse())
        
        let notEmptyString = "String"
        expect(notEmptyString.isNotEmpty).to(beTrue())
    }
    
    func test_Base64() {
        let stringToEncode = "String to encode"
        expect(stringToEncode.base64).to(equal("U3RyaW5nIHRvIGVuY29kZQ=="))
        
        let multilineStringToEncode = """
            Multiline
            literal
            to
            encode
            """
        expect(multilineStringToEncode.base64).to(equal("TXVsdGlsaW5lCmxpdGVyYWwKdG8KZW5jb2Rl"))
    }

    func test_InNewLine() {
        let newLineString = "\n"
        expect(newLineString.isNewLine).to(beTrue())
    }
    
}
