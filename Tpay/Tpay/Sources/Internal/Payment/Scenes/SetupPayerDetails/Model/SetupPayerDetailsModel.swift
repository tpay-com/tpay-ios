//
//  Copyright © 2023 Tpay. All rights reserved.
//

protocol SetupPayerDetailsModel: AnyObject {
    
    // MARK: - Properties
    
    var transaction: Transaction { get }
    var synchronizationStatus: Variable<Domain.SynchronizationStatus> { get }
}
