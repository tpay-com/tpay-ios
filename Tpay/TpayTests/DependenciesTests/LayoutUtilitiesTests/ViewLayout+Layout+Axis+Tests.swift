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

final class ViewLayout_Layout_Axis_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let parent = TestView()
    
    // MARK: - Tests
    
    // MARK: - XAxis
    
    func test_xAxis_CenterWithSibling() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .xAxis.center(with: parent)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.frame.width / 2, "Min X should be half the parent's width")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_xAxis_CenterWithLayoutGuide() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .xAxis.center(with: guide)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, guide.frame.width / 2, "Min X should be half the parent's width")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    // MARK: - YAxis
    
    func test_yAxis_CenterWithSibling() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .yAxis.center(with: parent)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, parent.frame.height / 2, "Min X should be half the parent's height")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_yAxis_CenterWithLayoutGuide() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .yAxis.center(with: guide)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, guide.frame.height / 2, "Min Y should be half the parent's height")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
}
