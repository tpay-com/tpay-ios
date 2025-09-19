//
//  Copyright © 2022 Tpay. All rights reserved.
//

struct AnyItem: Hashable {
    
    // MARK: - Properties
    
    private let base: AnyHashable
    
    // MARK: - Initializers
    
    init<ItemType: Hashable>(wrapping item: ItemType) {
        base = item
    }
    
    // MARK: - API
    
    func tryUnbox<ItemType: Hashable>() -> ItemType? { base as? ItemType }
    
}
