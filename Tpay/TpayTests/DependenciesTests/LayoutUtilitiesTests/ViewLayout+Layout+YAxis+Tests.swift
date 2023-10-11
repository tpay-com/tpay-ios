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

final class ViewLayout_Layout_YAxis_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let parent = TestView()
    
    // MARK: - Getters
    
    var direction: UserInterfaceLayoutDirection { parent.direction }
    
    // MARK: - Tests
    
    // MARK: - Relative to sibling
    
    // MARK: - Top
    
    func test_topEqualToSiblingTop() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.equalTo(parent, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 0, "Min Y should be equal to parent's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_topLessThanOrEqualToSiblingTop() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.lessThanOrEqualTo(parent, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 0, "Min Y should be less than or equal to the parent's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_topGreaterThanOrEqualToSiblingTop() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.greaterThanOrEqualTo(parent, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 0, "Min Y should be greater than or equal to the parent's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_topEqualToSiblingBottom() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.equalTo(parent, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 200, "Min Y should be equal to parent's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_topLessThanOrEqualToSiblingBottom() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.lessThanOrEqualTo(parent, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 200, "Min Y should be less than or equal to the parent's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_topGreaterThanOrEqualToSiblingBottom() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.greaterThanOrEqualTo(parent, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 200, "Min Y should be greater than or equal to the parent's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Bottom
    
    func test_bottomEqualToSiblingBottom() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.equalTo(parent, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 200, "Max Y should be equal to parent's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_bottomLessThanOrEqualToSiblingBottom() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.lessThanOrEqualTo(parent, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 200, "Max Y should be less than or equal to the parent's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_bottomGreaterThanOrEqualToSiblingBottom() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.greaterThanOrEqualTo(parent, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 200, "Max Y should be greater than or equal to the parent's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_bottomEqualToSiblingTop() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.equalTo(parent, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 0, "Max Y should be equal to parent's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_bottomLessThanOrEqualToSiblingTop() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.lessThanOrEqualTo(parent, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 0, "Max Y should be less than or equal to the parent's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_bottomGreaterThanOrEqualToSiblingTop() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.greaterThanOrEqualTo(parent, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 0, "Max Y should be greater than or equal to the parent's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Relative to layout guide
    
    // MARK: - Top
    
    func test_topEqualToLayoutGuideTop() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.equalTo(guide, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 0, "Min Y should be equal to guide's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_topLessThanOrEqualToLayoutGuideTop() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.lessThanOrEqualTo(guide, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 0, "Min Y should be less than or equal to the guide's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_topGreaterThanOrEqualToLayoutGuideTop() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.greaterThanOrEqualTo(guide, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 0, "Min Y should be greater than or equal to the guide's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_topEqualToLayoutGuideBottom() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.equalTo(guide, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 200, "Min Y should be equal to guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_topLessThanOrEqualToLayoutGuideBottom() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.lessThanOrEqualTo(guide, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 200, "Min Y should be less than or equal to the guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_topGreaterThanOrEqualToLayoutGuideBottom() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .top.greaterThanOrEqualTo(guide, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minY, 200, "Min Y should be greater than or equal to the guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Bottom
    
    func test_bottomEqualToLayoutGuideBottom() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.equalTo(guide, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 200, "Max Y should be equal to guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_bottomLessThanOrEqualToLayoutGuideBottom() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.lessThanOrEqualTo(guide, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 200, "Max Y should be less than or equal to the guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_bottomGreaterThanOrEqualToLayoutGuideBottom() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.greaterThanOrEqualTo(guide, .bottom)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 200, "Max Y should be greater than or equal to the guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_bottomEqualToLayoutGuideTop() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.equalTo(guide, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 0, "Max Y should be equal to guide's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_bottomLessThanOrEqualToLayoutGuideTop() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.lessThanOrEqualTo(guide, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 0, "Max Y should be less than or equal to the guide's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_bottomGreaterThanOrEqualToLayoutGuideTop() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .bottom.greaterThanOrEqualTo(guide, .top)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxY, 0, "Max Y should be greater than or equal to the guide's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
}
