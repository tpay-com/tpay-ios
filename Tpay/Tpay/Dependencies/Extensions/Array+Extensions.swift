//
//  Copyright © 2022 Tpay. All rights reserved.
//

extension Array {
    
    // MARK: - Properties
    
    var isNotEmpty: Bool { isEmpty == false }
    
    // MARK: - API
    
    mutating func append(_ element: @autoclosure () -> Iterator.Element, if condition: Bool) {
        if condition {
            append(element())
        }
    }
    
    mutating func append(contentsOf collection: [Iterator.Element], if condition: Bool) {
        if condition {
            append(contentsOf: collection)
        }
    }
    
    func distinct<ValueType: Hashable>(by keyPath: KeyPath<Element, ValueType>) -> [Element] {
        var itemsIdentifiers = Set<ValueType>()
        itemsIdentifiers.reserveCapacity(count)
        var uniqueItems: [Element] = []
        uniqueItems.reserveCapacity(count)
        
        for item in self where itemsIdentifiers.contains(item[keyPath: keyPath]) == false {
            uniqueItems.append(item)
            itemsIdentifiers.insert(item[keyPath: keyPath])
        }
        
        return uniqueItems
    }

    func max<Property: Comparable>(by keypath: KeyPath<Element, Property>, compared: (Property, Property) -> Bool = (<)) -> Element? {
        self.max { lhs, rhs in compared(lhs[keyPath: keypath], rhs[keyPath: keypath]) }
    }
    
}
