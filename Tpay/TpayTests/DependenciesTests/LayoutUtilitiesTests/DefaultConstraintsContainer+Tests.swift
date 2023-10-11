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

final class DefaultConstraintsContainer_Tests: XCTestCase {
    
    // MARK: - Properties
    
    private var view: View!
    private var childView: View!
    private var container: ConstraintsContainer!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        container = DefaultConstraintsContainer()
        view = TestView()
        childView = View()
        view.addSubview(childView)
    }
    
    // MARK: - Tests
    
    func test_AddConstraints_ConstraintsCount() {
        container.add(LayoutConstraint(item: view, itemAttribute: .width, relation: .equal, constant: 100))
        container.add(LayoutConstraint(item: view, itemAttribute: .height, relation: .equal, target: childView, targetAttribute: .height))
        
        let constraints = container.getConstraints()
        
        XCTAssertEqual(constraints.count, 2, "Container should contain 2 constraints")
    }
    
    func test_ActivateConstraints_AreActive() {
        container.add(LayoutConstraint(item: view, itemAttribute: .width, relation: .equal, constant: 100))
        container.add(LayoutConstraint(item: view, itemAttribute: .height, relation: .equal, target: childView, targetAttribute: .height))
        
        let receivedConstraints = container.getConstraints()
        
        container.activate()
        
        XCTAssertEqual(receivedConstraints.allSatisfy(\.isActive), true, "All constraints should be activated")
    }
    
    func test_ActivateConstraints_AreInactive() {
        container.add(LayoutConstraint(item: view, itemAttribute: .width, relation: .equal, constant: 100))
        container.add(LayoutConstraint(item: view, itemAttribute: .height, relation: .equal, target: childView, targetAttribute: .height))
        
        let receivedConstraints = container.getConstraints()
        
        XCTAssertEqual(receivedConstraints.allSatisfy { !$0.isActive }, true, "All constraints should not be activated")
    }
    
    func test_ActivateConstraints_ChunkIsActive() {
        container.add(LayoutConstraint(item: view, itemAttribute: .width, relation: .equal, constant: 100))
        container.add(LayoutConstraint(item: view, itemAttribute: .height, relation: .equal, target: childView, targetAttribute: .height))
        
        container.activate()
        
        container.add(LayoutConstraint(item: view, itemAttribute: .bottom, relation: .equal, target: childView, targetAttribute: .bottom))
        
        let constraints = container.getConstraints()
        
        XCTAssertEqual(constraints.count, 3, "Container should contain 3 constraints")
        XCTAssertEqual(constraints.filter(\.isActive).count, 2, "Only 2 constraints should be activated")
    }
    
    func test_AddConstraints_TranslatedCorrectly() {
        func check(constraint: NSLayoutConstraint, item: AnyObject, itemAttribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, target: AnyObject?, targetAttribute: NSLayoutConstraint.Attribute?, constant: CGFloat) {
            XCTAssertTrue(constraint.firstItem === view)
            XCTAssertEqual(constraint.firstAttribute, itemAttribute)
            XCTAssertEqual(constraint.relation, relation)
            XCTAssertTrue(constraint.secondItem === target)
            XCTAssertEqual(constraint.secondAttribute, targetAttribute)
            XCTAssertEqual(constraint.constant, constant)
        }
        
        container.add(LayoutConstraint(item: view, itemAttribute: .width, relation: .equal, constant: 100))
        container.add(LayoutConstraint(item: view, itemAttribute: .bottom, relation: .equal, target: childView, targetAttribute: .bottom))
        
        let constraints = container.getConstraints()
        
        check(constraint: constraints[0], item: view, itemAttribute: .width, relation: .equal, target: nil, targetAttribute: .notAnAttribute, constant: 100)
        check(constraint: constraints[1], item: view, itemAttribute: .bottom, relation: .equal, target: childView, targetAttribute: .bottom, constant: 0)
    }
    
    func test_GetConstraint_PrototypesTranslatedCorrectly() {
        let prototype = LayoutConstraint(item: view, itemAttribute: .width, relation: .equal, constant: 100)
        container.add(prototype)
        _ = container.getConstraint(for: prototype)
        
        let constraints = container.getConstraints()
        
        XCTAssertEqual(constraints.count, 1, "Container should contain only 1 constraint")
    }
    
}
