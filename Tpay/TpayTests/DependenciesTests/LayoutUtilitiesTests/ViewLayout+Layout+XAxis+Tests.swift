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

final class ViewLayout_Layout_XAxis_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let parent = TestView()
    
    // MARK: - Getters
    
    var direction: UserInterfaceLayoutDirection { parent.direction }
    
    // MARK: - Tests
    
    // MARK: - Relative to sibling
    
    // MARK: - Leading
    
    func test_leadingEqualToSiblingsLeading() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.equalTo(parent, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 0 : 200, "Min X should be equal to parent's leading anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_leadingLessThanOrEqualToSiblingsLeading() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.lessThanOrEqualTo(parent, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 0 : 200, "Min X should be less than or equal to the parent's leading anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_leadingGreaterThanOrEqualToSiblingsLeading() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.greaterThanOrEqualTo(parent, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 0 : 200, "Min X should be greater than or equal to the parent's leading anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_leadingEqualToSiblingsTrailing() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.equalTo(parent, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 200 : 0, "Min X should be equal to parent's trailing anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_leadingLessThanOrEqualToSiblingsTrailing() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.lessThanOrEqualTo(parent, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 200 : 0, "Min X should be less than or equal to the parent's trailing anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_leadingGreaterThanOrEqualToSiblingsTrailing() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.greaterThanOrEqualTo(parent, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 200 : 0, "Min X should be greater than or equal to the parent's trailing anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Trailing
    
    func test_trailingEqualToSiblingsTrailing() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.equalTo(parent, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 200 : 0, "Max X should be equal to parent's trailing anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_trailingLessThanOrEqualToSiblingsTrailing() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.lessThanOrEqualTo(parent, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 200 : 0, "Max X should be less than or equal to the parent's trailing anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_trailingGreaterThanOrEqualToSiblingsTrailing() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.greaterThanOrEqualTo(parent, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 200 : 0, "Max X should be greater than or equal to the parent's trailing anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_trailingEqualToSiblingsLeading() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.equalTo(parent, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 0 : 200, "Max X should be equal to parent's leading anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_trailingLessThanOrEqualToSiblingsLeading() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.lessThanOrEqualTo(parent, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 0 : 200, "Max X should be less than or equal to the parent's leading anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_trailingGreaterThanOrEqualToSiblingsLeading() {
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.greaterThanOrEqualTo(parent, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 0 : 200, "Max X should be greater than or equal to the parent's leading anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Relative to layout guide
    
    // MARK: - Leading
    
    func test_leadingEqualToLayoutGuideLeading() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.equalTo(guide, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 0 : 200, "Min X should be equal to guide's leading anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_leadingLessThanOrEqualToLayoutGuideLeading() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.lessThanOrEqualTo(guide, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 0 : 200, "Min X should be less than or equal to the guide's leading anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_leadingGreaterThanOrEqualToLayoutGuideLeading() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.greaterThanOrEqualTo(guide, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 0 : 200, "Min X should be greater than or equal to the guide's leading anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_leadingEqualToLayoutGuideTrailing() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.equalTo(guide, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 200 : 0, "Min X should be equal to guide's trailing anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_leadingLessThanOrEqualToLayoutGuideTrailing() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.lessThanOrEqualTo(guide, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 200 : 0, "Min X should be less than or equal to the guide's trailing anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_leadingGreaterThanOrEqualToLayoutGuideTrailing() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .leading.greaterThanOrEqualTo(guide, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.minX, parent.direction == .leftToRight ? 200 : 0, "Min X should be greater than or equal to the guide's trailing anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    // MARK: - Trailing
    
    func test_trailingEqualToLayoutGuideTrailing() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.equalTo(guide, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 200 : 0, "Max X should be equal to guide's trailing anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_trailingLessThanOrEqualToLayoutGuideTrailing() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.lessThanOrEqualTo(guide, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 200 : 0, "Max X should be less than or equal to the guide's trailing anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_trailingGreaterThanOrEqualToLayoutGuideTrailing() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.greaterThanOrEqualTo(guide, .trailing)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 200 : 0, "Max X should be greater than or equal to the guide's trailing anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_trailingEqualToLayoutGuideLeading() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.equalTo(guide, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 0 : 200, "Max X should be equal to guide's leading anchor position")
        XCTAssertEqual(constraint.relation, .equal, "Relation should be equal")
    }
    
    func test_trailingLessThanOrEqualToLayoutGuideLeading() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.lessThanOrEqualTo(guide, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 0 : 200, "Max X should be less than or equal to the guide's leading anchor position")
        XCTAssertEqual(constraint.relation, .lessThanOrEqual, "Relation should be greater than or equal")
    }
    
    func test_trailingGreaterThanOrEqualToLayoutGuideLeading() {
        let guide = parent.layoutGuide
        let view = TestView()
        let constraint = view.layout
            .add(to: parent)
            .trailing.greaterThanOrEqualTo(guide, .leading)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.maxX, parent.direction == .leftToRight ? 0 : 200, "Max X should be greater than or equal to the guide's leading anchor position")
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual, "Relation should be greater than or equal")
    }
    
}
