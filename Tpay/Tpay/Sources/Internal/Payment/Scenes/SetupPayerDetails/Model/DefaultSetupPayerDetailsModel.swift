//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultSetupPayerDetailsModel: SetupPayerDetailsModel {
    
    // MARK: - Events
    
    private(set) lazy var synchronizationStatus = synchronizationService.synchronizationStatus
    
    // MARK: - Properties
    
    let transaction: Transaction
    
    private let synchronizationService: SynchronizationService
    
    // MARK: - Initialization
    
    convenience init(transaction: Transaction, using resolver: ServiceResolver) {
        self.init(transaction: transaction, synchronizationService: resolver.resolve())
    }
    
    init(transaction: Transaction, synchronizationService: SynchronizationService) {
        self.transaction = transaction
        self.synchronizationService = synchronizationService
    }
}
