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

final class LayoutGuideLayout_Layout_Dimension_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let parent = TestView()
    
    // MARK: - Tests
    
    // MARK: - Height
    
    func test_height_EqualToConstant() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .height.equalTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_height_LessThanOrEqualToConstant() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .height.lessThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(guide.frame.height, 200, "Height should be 200 or less")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be lessThanOrEqual")
    }
    
    func test_height_GreaterThanOrEqualToConstant() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .height.greaterThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(guide.frame.height, 200, "Height should be 200 or more")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greaterThanOrEqual")
    }
    
    func test_height_EqualToSibling() {
        let guide = LayoutGuide()
        print(parent.frame)
        let constraint = guide.layout
            .add(to: parent)
            .height.equalTo(parent, .height)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_height_LessThanOrEqualToSibling() {
        let guide = LayoutGuide()
        print(parent.frame)
        let constraint = guide.layout
            .add(to: parent)
            .height.equalTo(parent, .height)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(guide.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be lessThanOrEqual")
    }
    
    func test_height_GreaterThanOrEqualToSibling() {
        let guide = LayoutGuide()
        print(parent.frame)
        let constraint = guide.layout
            .add(to: parent)
            .height.equalTo(parent, .height)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(guide.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be greaterThanOrEqual")
    }
    
    // MARK: - Width
    
    func test_width_EqualToConstant() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .width.equalTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_width_LessThanOrEqualToConstant() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .width.lessThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(guide.frame.width, 200, "Width should be 200 or less")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be lessThanOrEqual")
    }
    
    func test_width_GreaterThanOrEqualToConstant() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .width.greaterThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(guide.frame.width, 200, "Width should be 200 or more")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greaterThanOrEqual")
    }
    
    func test_width_EqualToSibling() {
        let guide = LayoutGuide()
        print(parent.frame)
        let constraint = guide.layout
            .add(to: parent)
            .width.equalTo(parent, .width)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_width_LessThanOrEqualToSibling() {
        let guide = LayoutGuide()
        print(parent.frame)
        let constraint = guide.layout
            .add(to: parent)
            .width.equalTo(parent, .width)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(guide.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be lessThanOrEqual")
    }
    
    func test_width_GreaterThanOrEqualToSibling() {
        let guide = LayoutGuide()
        print(parent.frame)
        let constraint = guide.layout
            .add(to: parent)
            .width.equalTo(parent, .width)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(guide.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be greaterThanOrEqual")
    }
    
}
