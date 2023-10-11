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

final class LayoutGuideLayout_Layout_Axis_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let parent = TestView()
    
    // MARK: - Tests
    
    // MARK: - XAxis
    
    func test_xAxis_CenterWithSibling() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .xAxis.center(with: parent)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.minX, parent.frame.width / 2, "Min X should be half the parent's width")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_xAxis_CenterWithLayoutGuide() {
        let siblingGuide = parent.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .xAxis.center(with: siblingGuide)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.minX, siblingGuide.frame.width / 2, "Min X should be half the sibling's layout guide width")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    // MARK: - YAxis
    
    func test_yAxis_CenterWithSibling() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .yAxis.center(with: parent)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.minY, parent.frame.height / 2, "Min Y should be half the parent's height")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_yAxis_CenterWithLayoutGuide() {
        let siblingGuide = parent.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .yAxis.center(with: siblingGuide)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.minY, siblingGuide.frame.height / 2, "Min Y should be half the sibling's guide height")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
}
