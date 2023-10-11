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

final class DefaultLayoutResult_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private let parent = TestView()
    
    // MARK: - Tests
    
    // MARK: - ConstraintMultiplier
    
    func test_ViewHeight_EqualToParentHeight_Multiplied() {
        let multiplier: CGFloat = 1.5
        let view = View()
        let constraint = view.layout
            .add(to: parent)
            .height.equalTo(parent, .height).multiplied(by: multiplier)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(view.frame.height, parent.height * multiplier, "Height should be \(multiplier * parent.height)")
        XCTAssertEqual(constraint.multiplier, multiplier, "Multiplier should be \(multiplier)")
    }
    
    func test_LayoutGuideHeight_EqualToParentHeight_Multiplied() {
        let multiplier: CGFloat = 1.5
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .height.equalTo(parent, .height).multiplied(by: multiplier)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(guide.frame.height, parent.height * multiplier, "Height should be \(multiplier * parent.height)")
        XCTAssertEqual(constraint.multiplier, multiplier, "Multiplier should be \(multiplier)")
    }
    
    // MARK: - ConstraintPrioritizer
    
    func test_ViewHeight_EqualToParentHeight_Prioritized() {
        let priority: Float = 50
        let view = View()
        let constraint = view.layout
            .add(to: parent)
            .height.equalTo(parent, .height).with(priority: priority)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(constraint.priority.rawValue, priority, "Priority should be \(priority)")
    }
    
    func test_LayoutGuideHeight_EqualToParentHeight_Prioritized() {
        let priority: Float = 50
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .height.equalTo(parent, .height).with(priority: priority)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(constraint.priority.rawValue, priority, "Priority should be \(priority)")
    }
    
    // MARK: - ConstraintConstantizer
    
    func test_ViewTop_EqualToParentTop_WithConstant() {
        let constant: CGFloat = 50
        let view = View()
        let constraint = view.layout
            .add(to: parent)
            .top.equalTo(parent, .top).with(constant: constant)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(constraint.constant, constant, "Constant should be \(constant)")
        XCTAssertEqual(view.frame.minY, constant, "Min Y should be equal to parent's top anchor position plus \(constant)")
    }
    
    func test_LayoutGuideTop_EqualToParentTop_WithConstant() {
        let constant: CGFloat = 50
        let guide = LayoutGuide()
        let constraint = guide.layout
            .add(to: parent)
            .top.equalTo(parent, .top).with(constant: constant)
            .activate()
            .constraint
        parent.prepare()
        XCTAssertEqual(constraint.constant, constant, "Constant should be \(constant)")
        XCTAssertEqual(guide.frame.minY, constant, "Min Y should be equal to parent's top anchor position plus \(constant)")
    }
    
}
