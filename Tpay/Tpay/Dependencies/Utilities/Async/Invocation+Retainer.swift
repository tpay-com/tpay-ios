//
//  Copyright © 2022 Tpay. All rights reserved.
//

import Foundation

extension Invocation {
    
    final class Retainer {
        
        // MARK: - Static properties
        
        static let instance = Retainer()
        
        // MARK: - Properties
        
        private let lock = NSLock()
        private var items: [UUID: AnyObject] = [:]
        
        // MARK: - Initializers
        
        init() {}
        
        // MARK: - API
        
        func retain(_ object: AnyObject, for uuid: UUID) {
            lock.lock()
            defer { lock.unlock() }
            items[uuid] = object
        }
        
        func releaseObject(with uuid: UUID) {
            lock.lock()
            defer { lock.unlock() }
            items[uuid] = nil
        }
        
    }
    
}
