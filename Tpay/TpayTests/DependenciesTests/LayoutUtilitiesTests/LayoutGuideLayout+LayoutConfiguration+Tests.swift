//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

@testable import Tpay
import XCTest

final class LayoutGuideLayout_LayoutConfiguration_Tests: XCTestCase {
    
    // MARK: - Properties
    
    let parent = TestView()
    
    // MARK: - Tests
    
    func test_AddTo_ParentResult() {
        let guide = LayoutGuide()
        guide.layout.add(to: parent)
        XCTAssertTrue(parent.layoutGuides.contains(guide), "Parent view should contain the layout guide")
    }
    
    func test_AddTo_ParentReturnType() {
        let guide = LayoutGuide()
        XCTAssert(guide.layout.add(to: parent) is LayoutConfiguration, "Function should return LayoutConfiguration")
    }
    
}
