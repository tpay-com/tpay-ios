//
//  Copyright © 2022 Tpay. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#else
    import AppKit
#endif

final class LayoutConstraint {
    
    // MARK: - Properties
    
    let item: AnyHashable
    let itemAttribute: NSLayoutConstraint.Attribute
    let relation: NSLayoutConstraint.Relation
    let target: AnyHashable?
    let targetAttribute: NSLayoutConstraint.Attribute
    var multiplier: CGFloat = 1.0
    var constant: CGFloat = 0
    var priority: LayoutPriority?
    
    // MARK: - Initializers
    
    init(item: AnyHashable, itemAttribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, constant: CGFloat) {
        self.item = item
        self.itemAttribute = itemAttribute
        self.relation = relation
        self.constant = constant
        targetAttribute = .notAnAttribute
        target = nil
    }
    
    init(item: AnyHashable, itemAttribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, target: AnyHashable, targetAttribute: NSLayoutConstraint.Attribute) {
        self.item = item
        self.itemAttribute = itemAttribute
        self.relation = relation
        self.target = target
        self.targetAttribute = targetAttribute
    }
    
    // MARK: - Internal
    
    func set(multiplier: CGFloat) {
        self.multiplier = multiplier
    }
    
    func set(constant: CGFloat) {
        self.constant = constant
    }
    
    func set(priority: LayoutPriority) {
        self.priority = priority
    }
    
}
