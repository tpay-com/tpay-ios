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

final class ViewLayout_ViewLayoutConfiguration_Tests: XCTestCase {
    
    // MARK: - Tests
    
    func test_Add_OneSubTestView() {
        let parent = TestView()
        let child = TestView()
        parent.layout.add(subviews: child)
        XCTAssertTrue(parent.subviews.contains(child), "Parent view should contain the child view")
    }
    
    func test_Add_MultipleSubviews() {
        let parent = TestView()
        let firstChild = TestView()
        let secondChild = TestView()
        parent.layout.add(subviews: firstChild, secondChild)
        XCTAssertTrue(parent.subviews.contains(firstChild), "Parent view should contain the first child view")
        XCTAssertTrue(parent.subviews.contains(secondChild), "Parent view should contain the second child view")
    }
    
}
