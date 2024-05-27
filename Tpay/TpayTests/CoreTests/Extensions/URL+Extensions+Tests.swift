//
//  Copyright © 2024 Tpay. All rights reserved.
//

import Foundation
import Nimble
import XCTest

@testable import Tpay

final class URL_Extensions_Tests: XCTestCase {
    
    func test_Normalize() {
        let normalizedUrl = URL(safeString: "https://google.com/")
        
        expect(URL(safeString: "https://google.com").normalized).to(equal(normalizedUrl))
        expect(URL(safeString: "https://google.com/").normalized).to(equal(normalizedUrl))
        expect(URL(safeString: "https://www.google.com").normalized).to(equal(normalizedUrl))
        expect(URL(safeString: "https://www.google.com/").normalized).to(equal(normalizedUrl))
        
        let normalizedUrlWithQueryParams = URL(safeString: "https://google.com/?key=value")
        
        expect(URL(safeString: "https://google.com?key=value").normalized).to(equal(normalizedUrlWithQueryParams))
        expect(URL(safeString: "https://google.com/?key=value").normalized).to(equal(normalizedUrlWithQueryParams))
        expect(URL(safeString: "https://www.google.com?key=value").normalized).to(equal(normalizedUrlWithQueryParams))
        expect(URL(safeString: "https://www.google.com/?key=value").normalized).to(equal(normalizedUrlWithQueryParams))
    }
}
