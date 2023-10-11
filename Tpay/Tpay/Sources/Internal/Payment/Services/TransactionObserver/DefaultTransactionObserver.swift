//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class DefaultTransactionObserver: TransactionObserver {
    
    // MARK: - Properties
    
    let status = Observable<Domain.OngoingTransaction.Status>()
    
    private let transaction: Domain.OngoingTransaction
    private let poller: TransactionStatusPoller
    private let mapper: TransportationToDomainModelsMapper
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    convenience init(transaction: Domain.OngoingTransaction, resolver: ServiceResolver) {
        self.init(transaction: transaction, networkingService: resolver.resolve(), mapper: DefaultTransportationToDomainModelsMapper())
    }
    
    init(transaction: Domain.OngoingTransaction, networkingService: NetworkingService, mapper: TransportationToDomainModelsMapper) {
        self.transaction = transaction
        self.mapper = mapper
        poller = TransactionStatusPoller(for: transaction.transactionId, using: networkingService)
    }
    
    // MARK: - API
    
    func startObserving() {
        poller.result
            .mapStatus(using: mapper)
            .subscribe(onNext: { [weak self] status in self?.status.on(.next(status)) })
            .add(to: disposer)
        
        poller.startPolling()
    }
    
    func stopObserving() {
        disposer.disposeAll()
        poller.cancel()
    }
}

private extension Observable where T == Result<TransactionsController.SpecifiedTransaction.ResponseType, Error> {
    
    func mapStatus(using mapper: TransportationToDomainModelsMapper) -> Observable<Domain.OngoingTransaction.Status> {
        self
            .map { result in
                switch result {
                case .success(let dto):
                    return mapper.makeOngoingTransaction(from: dto).status
                case .failure(let error):
                    return Domain.OngoingTransaction.Status.error(error)
                }
            }
    }
}
