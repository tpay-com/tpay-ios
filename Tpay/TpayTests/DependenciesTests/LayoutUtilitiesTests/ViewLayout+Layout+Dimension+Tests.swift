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

final class ViewLayout_Layout_Dimension_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let parent = TestView()
    
    // MARK: - Tests
    
    // MARK: - Height
    
    func test_Height_EqualToConstant() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .height.equalTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Height_LessThanOrEqualToConstant() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .height.lessThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(view.frame.height, 200, "Height should be 200 or less")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be lessThanOrEqual")
    }
    
    func test_Height_GreaterThanOrEqualToConstant() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .height.greaterThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(view.frame.height, 200, "Height should be 200 or more")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greaterThanOrEqual")
    }
    
    func test_Height_EqualToSibling() {
        let view = TestView()
        print(parent.frame)
        let constraint = view.layout
            .add(to: parent)
            .height.equalTo(parent, .height)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Height_LessThanOrEqualToSibling() {
        let view = TestView()
        print(parent.frame)
        let constraint = view.layout
            .add(to: parent)
            .height.equalTo(parent, .height)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(view.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be lessThanOrEqual")
    }
    
    func test_Height_GreaterThanOrEqualToSibling() {
        let view = TestView()
        print(parent.frame)
        let constraint = view.layout
            .add(to: parent)
            .height.equalTo(parent, .height)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(view.frame.height, 200, "Height should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be greaterThanOrEqual")
    }
    
    // MARK: - Width
    
    func test_Width_EqualToConstant() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .width.equalTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Width_LessThanOrEqualToConstant() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .width.lessThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(view.frame.width, 200, "Width should be 200 or less")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be lessThanOrEqual")
    }
    
    func test_Width_GreaterThanOrEqualToConstant() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .width.greaterThanOrEqualTo(constant: 200)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(view.frame.width, 200, "Width should be 200 or more")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greaterThanOrEqual")
    }
    
    func test_Width_EqualToSibling() {
        let view = TestView()
        print(parent.frame)
        let constraint = view.layout
            .add(to: parent)
            .width.equalTo(parent, .width)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Width_LessThanOrEqualToSibling() {
        let view = TestView()
        print(parent.frame)
        let constraint = view.layout
            .add(to: parent)
            .width.equalTo(parent, .width)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertLessThanOrEqual(view.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be lessThanOrEqual")
    }
    
    func test_Width_GreaterThanOrEqualToSibling() {
        let view = TestView()
        print(parent.frame)
        let constraint = view.layout
            .add(to: parent)
            .width.equalTo(parent, .width)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertGreaterThanOrEqual(view.frame.width, 200, "Width should be 200")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be greaterThanOrEqual")
    }
    
}
