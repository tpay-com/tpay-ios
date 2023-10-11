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

final class ViewLayout_LayoutConfiguration_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_AddTo_ParentResult() {
        let parent = TestView()
        let child = TestView()
        child.layout.add(to: parent)
        XCTAssertTrue(parent.subviews.contains(child), "Parent view should contain the child view")
    }
    
    func test_AddTo_ParentReturnType() {
        let parent = TestView()
        let child = TestView()
        XCTAssert(child.layout.add(to: parent) is ViewLayoutConfiguration, "Function should return ViewLayoutConfiguration")
    }
    
}
