//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Nimble
@testable import Tpay
import XCTest

final class FeatureFlags_Tests: XCTestCase {

    func test_EnableFeatureFlag() {
        var sut = FeatureFlags()
        sut.enable(feature: .feature1Enabled)
        
        expect(sut.isEnabled(feature: .feature1Enabled)) == true
    }
    
    func test_DisableFeatureFlag() {
        var sut = [FeatureFlag.feature2Enabled, FeatureFlag.feature1Enabled]
        sut.disable(feature: .feature2Enabled)
        
        expect(sut.isEnabled(feature: .feature2Enabled)) == false
        expect(sut.isEnabled(feature: .feature1Enabled)) == true
    }

}

private extension FeatureFlag {
    
    static let feature1Enabled = FeatureFlag(rawValue: "feature1Enabled")
    static let feature2Enabled = FeatureFlag(rawValue: "feature2Enabled")

}
