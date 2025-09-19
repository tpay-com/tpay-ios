//
//  Copyright © 2022 Tpay. All rights reserved.
//

protocol ListSection: Hashable {

    // MARK: - Type Aliases
    
    associatedtype ItemType: Hashable
    
    // MARK: - Properties
    
    var items: [ItemType] { get }
    
}

extension ListSection {
    
    var boxed: AnySection { AnySection(wrapping: self) }
    
}
