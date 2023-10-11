//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class TpayModule_Tests: XCTestCase {
 
    // MARK: - Tests
    
    func test_ConfigureLanguages() {
        expect(try TpayModule.configure(paymentMethods: [])).to(throwError(errorType: MerchantConfigurationError.self))
        
        expect(try TpayModule.configure(preferredLanguage: .en, supportedLanguages: [])).to(throwError(errorType: ModuleConfigurationError.self))
        expect(try TpayModule.configure(preferredLanguage: .en, supportedLanguages: [.pl])).to(throwError(errorType: ModuleConfigurationError.self))
        expect(try TpayModule.configure(preferredLanguage: .pl, supportedLanguages: [.en])).to(throwError(errorType: ModuleConfigurationError.self))
        
        expect(try TpayModule.configure(paymentMethods: [.card])).notTo(throwError(errorType: ModuleConfigurationError.self))
        
        expect(try TpayModule.configure(preferredLanguage: .en)).notTo(throwError(errorType: ModuleConfigurationError.self))
        expect(try TpayModule.configure(preferredLanguage: .pl)).notTo(throwError(errorType: ModuleConfigurationError.self))
        expect(try TpayModule.configure(preferredLanguage: .en, supportedLanguages: [.en])).notTo(throwError(errorType: ModuleConfigurationError.self))
        expect(try TpayModule.configure(preferredLanguage: .pl, supportedLanguages: [.pl])).notTo(throwError(errorType: ModuleConfigurationError.self))
    }
}
