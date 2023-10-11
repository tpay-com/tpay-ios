//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension Domain {
    
    enum SynchronizationStatus: Equatable {

        // MARK: - Cases
        
        case idle
        case syncing
        case finished
        
        case error(Error)
    }
}

extension Domain.SynchronizationStatus {
    
    static func == (lhs: Domain.SynchronizationStatus, rhs: Domain.SynchronizationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.syncing, .syncing), (.finished, .finished), (.error, .error):
            return true
        default:
            return false
        }
    }
}
