//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

/// Bag over WorkingItem elements
final class WorkingItems {
    
    // MARK: - Properties
    
    private var items: [UUID: WorkingItem] = [:]
    
    // MARK: - Initializers
    
    init() {}
    
    deinit {
        cancelAll()
    }
    
    // MARK: - API
    
    /// Append new cancellable task to retain
    /// - Parameters:
    ///   - item: cancellable task wrapper
    ///   - uuid: task identifier
    func append(_ item: WorkingItem, for uuid: UUID) {
        items[uuid] = item
    }
    
    /// Release cancellable task
    /// - Parameter uuid: task identifier
    func removeItem(with uuid: UUID) {
        items[uuid]?.cancel()
        items[uuid] = nil
    }
    
    /// Release all cancellable tasks
    func cancelAll() {
        items.values.forEach { item in item.cancel() }
        items.removeAll()
    }
    
}
