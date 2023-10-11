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

final class LayoutGuideLayout_Layout_YAxis_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let view = TestView()
    
    // MARK: - Getters
    
    var direction: UserInterfaceLayoutDirection { view.direction }
    
    // MARK: - Tests
    
    // MARK: - Relative to view
    
    // MARK: - Top
    
    func test_Top_EqualToViewTop() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.equalTo(view, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 0, "Min Y should be equal to view's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Top_LessThanOrEqualToViewTop() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.lessThanOrEqualTo(view, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 0, "Min Y should be less than or equal to the view's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Top_GreaterThanOrEqualToViewTop() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.greaterThanOrEqualTo(view, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 0, "Min Y should be greater than or equal to the view's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Top_EqualToViewBottom() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.equalTo(view, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 200, "Min Y should be equal to view's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Top_LessThanOrEqualToViewBottom() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.lessThanOrEqualTo(view, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 200, "Min Y should be less than or equal to the view's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Top_GreaterThanOrEqualToViewBottom() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.greaterThanOrEqualTo(view, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 200, "Min Y should be greater than or equal to the view's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Bottom
    
    func test_Bottom_EqualToViewBottom() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.equalTo(view, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 200, "Max Y should be equal to view's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Bottom_LessThanOrEqualToViewBottom() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.lessThanOrEqualTo(view, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 200, "Max Y should be less than or equal to the view's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Bottom_GreaterThanOrEqualToViewBottom() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.greaterThanOrEqualTo(view, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 200, "Max Y should be greater than or equal to the view's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Bottom_EqualToViewTop() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.equalTo(view, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 0, "Max Y should be equal to view's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Bottom_LessThanOrEqualToViewTop() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.lessThanOrEqualTo(view, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 0, "Max Y should be less than or equal to the view's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Bottom_GreaterThanOrEqualToViewTop() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.greaterThanOrEqualTo(view, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 0, "Max Y should be greater than or equal to the view's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Relative to layout guide
    
    // MARK: - Top
    
    func test_Top_EqualToLayoutGuideTop() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.equalTo(siblingGuide, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 0, "Min Y should be equal to sibling guide's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Top_LessThanOrEqualToLayoutGuideTop() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.lessThanOrEqualTo(siblingGuide, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 0, "Min Y should be less than or equal to the sibling guide's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Top_GreaterThanOrEqualToLayoutGuideTop() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.greaterThanOrEqualTo(siblingGuide, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 0, "Min Y should be greater than or equal to the sibling guide's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Top_EqualToLayoutGuideBottom() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.equalTo(siblingGuide, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 200, "Min Y should be equal to sibling guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Top_LessThanOrEqualToLayoutGuideBottom() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.lessThanOrEqualTo(siblingGuide, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 200, "Min Y should be less than or equal to the sibling guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Top_GreaterThanOrEqualToLayoutGuideBottom() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .top.greaterThanOrEqualTo(siblingGuide, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minY, 200, "Min Y should be greater than or equal to the sibling guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Bottom
    
    func test_Bottom_EqualToLayoutGuideBottom() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.equalTo(siblingGuide, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 200, "Max Y should be equal to sibling guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Bottom_LessThanOrEqualToLayoutGuideBottom() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.lessThanOrEqualTo(siblingGuide, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 200, "Max Y should be less than or equal to the sibling guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Bottom_GreaterThanOrEqualToLayoutGuideBottom() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.greaterThanOrEqualTo(siblingGuide, .bottom)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 200, "Max Y should be greater than or equal to the sibling guide's bottom anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Bottom_EqualToLayoutGuideTop() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.equalTo(siblingGuide, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 0, "Max Y should be equal to sibling guide's top anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Bottom_LessThanOrEqualToLayoutGuideTop() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.lessThanOrEqualTo(siblingGuide, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 0, "Max Y should be less than or equal to the sibling guide's top anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Bottom_GreaterThanOrEqualToLayoutGuideTop() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .bottom.greaterThanOrEqualTo(siblingGuide, .top)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxY, 0, "Max Y should be greater than or equal to the sibling guide's top anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
}
