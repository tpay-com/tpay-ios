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

final class LayoutGuideLayout_Layout_XAxis_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let view = TestView()
    
    // MARK: - Getters
    
    var direction: UserInterfaceLayoutDirection { view.direction }
    
    // MARK: - Tests
    
    // MARK: - Relative to view
    
    // MARK: - Leading
    
    func test_Leading_EqualToViewLeading() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.equalTo(view, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 0 : 200, "Min X should be equal to view's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Leading_LessThanOrEqualToViewLeading() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.lessThanOrEqualTo(view, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 0 : 200, "Min X should be less than or equal to the view's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Leading_GreaterThanOrEqualToViewLeading() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.greaterThanOrEqualTo(view, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 0 : 200, "Min X should be greater than or equal to the view's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Leading_EqualToViewTrailing() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.equalTo(view, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 200 : 0, "Min X should be equal to view's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Leading_LessThanOrEqualToViewTrailing() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.lessThanOrEqualTo(view, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 200 : 0, "Min X should be less than or equal to the view's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Leading_GreaterThanOrEqualToViewTrailing() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.greaterThanOrEqualTo(view, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 200 : 0, "Min X should be greater than or equal to the view's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Trailing
    
    func test_Trailing_EqualToViewTrailing() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.equalTo(view, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 200 : 0, "Max X should be equal to view's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Trailing_LessThanOrEqualToViewTrailing() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.lessThanOrEqualTo(view, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 200 : 0, "Max X should be less than or equal to the view's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Trailing_GreaterThanOrEqualToViewTrailing() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.greaterThanOrEqualTo(view, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 200 : 0, "Max X should be greater than or equal to the view's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Trailing_EqualToViewLeading() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.equalTo(view, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 0 : 200, "Max X should be equal to view's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Trailing_LessThanOrEqualToViewLeading() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.lessThanOrEqualTo(view, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 0 : 200, "Max X should be less than or equal to the view's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Trailing_GreaterThanOrEqualToViewLeading() {
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.greaterThanOrEqualTo(view, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 0 : 200, "Max X should be greater than or equal to the view's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Relative to layout guide
    
    // MARK: - Leading
    
    func test_Leading_EqualToLayoutGuideLeading() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.equalTo(siblingGuide, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 0 : 200, "Min X should be equal to sibling guide's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Leading_LessThanOrEqualToLayoutGuideLeading() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.lessThanOrEqualTo(siblingGuide, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 0 : 200, "Min X should be less than or equal to the sibling guide's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Leading_GreaterThanOrEqualToLayoutGuideLeading() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.greaterThanOrEqualTo(siblingGuide, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 0 : 200, "Min X should be greater than or equal to the sibling guide's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Leading_EqualToLayoutGuideTrailing() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.equalTo(siblingGuide, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 200 : 0, "Min X should be equal to sibling guide's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Leading_LessThanOrEqualToLayoutGuideTrailing() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.lessThanOrEqualTo(siblingGuide, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 200 : 0, "Min X should be less than or equal to the sibling guide's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Leading_GreaterThanOrEqualToLayoutGuideTrailing() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .leading.greaterThanOrEqualTo(siblingGuide, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.minX, view.direction == .leftToRight ? 200 : 0, "Min X should be greater than or equal to the sibling guide's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Trailing
    
    func test_Trailing_EqualToLayoutGuideTrailing() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.equalTo(siblingGuide, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 200 : 0, "Max X should be equal to sibling guide's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Trailing_LessThanOrEqualToLayoutGuideTrailing() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.lessThanOrEqualTo(siblingGuide, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 200 : 0, "Max X should be less than or equal to the sibling guide's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Trailing_GreaterThanOrEqualToLayoutGuideTrailing() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.greaterThanOrEqualTo(siblingGuide, .trailing)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 200 : 0, "Max X should be greater than or equal to the sibling guide's trailing_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Trailing_EqualToLayoutGuideLeading() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.equalTo(siblingGuide, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 0 : 200, "Max X should be equal to sibling guide's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_Trailing_LessThanOrEqualToLayoutGuideLeading() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.lessThanOrEqualTo(siblingGuide, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 0 : 200, "Max X should be less than or equal to the sibling guide's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_Trailing_GreaterThanOrEqualToLayoutGuideLeading() {
        let siblingGuide = view.layoutGuide
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: view)
            .trailing.greaterThanOrEqualTo(siblingGuide, .leading)
            .activate()
            .constraint
        view.prepare()
        XCTAssertEqual(guide.frame.maxX, view.direction == .leftToRight ? 0 : 200, "Max X should be greater than or equal to the sibling guide's leading_ anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
}
