//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class DefaultCardTokenPaymentModel: CardTokenPaymentModel {
    
    // MARK: - Properties
    
    let onPaymentCompleted = Observable<TransactionId>()
    let onPaymentFailed = Observable<TransactionId>()
    let errorOcured = Observable<PaymentError>()
    let transactionWithUrlOccured = Observable<Domain.OngoingTransaction>()
    
    private var transactionObserver: TransactionObserver?
    
    private let cardToken: Domain.CardToken
    private let transaction: Domain.Transaction
    
    private let transactionService: TransactionService
    private let synchronizationService: SynchronizationService
    private let resolver: ServiceResolver
    
    private let disposer = Disposer()
    
    // MARK: - Initializers
    
    convenience init(for transaction: Domain.Transaction, with cardToken: Domain.CardToken, using resolver: ServiceResolver) {
        self.init(for: transaction,
                  with: cardToken,
                  transactionService: DefaultTransactionService(using: resolver),
                  synchronizationService: resolver.resolve(),
                  resolver: resolver)
    }
    
    init(for transaction: Domain.Transaction,
         with cardToken: Domain.CardToken,
         transactionService: TransactionService,
         synchronizationService: SynchronizationService,
         resolver: ServiceResolver) {
        self.transaction = transaction
        self.cardToken = cardToken
        self.transactionService = transactionService
        self.synchronizationService = synchronizationService
        self.resolver = resolver
    }
    
    // MARK: - API
    
    func invokePayment() {
        Invocation.Queue()
            .append(synchronizationService.fetchPaymentData)
            .invoke(completion: { [weak self] result in
                self?.handle(synchronizationResult: result)
            })
    }
    
    // MARK: - Private
    
    private func handle(synchronizationResult: Result<Void, Error>) {
        switch synchronizationResult {
        case .success:
            payment()
        case .failure(let error):
            errorOcured.on(.next(PaymentError.cannotMakeTransaction(description: error.localizedDescription)))
        }
    }
    
    private func payment() {
        transactionService.invokePayment(for: transaction, with: cardToken, ignoreErrorsWhenContinueUrlExists: true) { [weak self] ongoingTransactionResult in
            self?.handle(ongoingTransactionResult: ongoingTransactionResult)
        }
    }
    
    private func handle(ongoingTransactionResult: OngoingTransactionResult) {
        switch ongoingTransactionResult {
        case .success(let ongoingTransaction):
            let hasErrors = ongoingTransaction.paymentErrors?.isNotEmpty ?? false
            if hasErrors && ongoingTransaction.continueUrl != nil {
                transactionWithUrlOccured.on(.next(ongoingTransaction))
                return
            }
            startObserving(ongoingTransaction)
        case .failure(let error):
            errorOcured.on(.next(PaymentError.cannotMakeTransaction(description: error.localizedDescription)))
        }
    }
    
    private func startObserving(_ transaction: Domain.OngoingTransaction) {
        transactionObserver = DefaultTransactionObserver(transaction: transaction, resolver: resolver)
        
        transactionObserver?.status
            .subscribe(onNext: { [weak self] status in
                self?.handle(transactionStatus: status, for: transaction.transactionId)
            })
            .add(to: disposer)
        
        transactionObserver?.startObserving()
    }
    
    private func stopObserving() {
        transactionObserver?.stopObserving()
        transactionObserver = nil
    }
    
    private func handle(transactionStatus: Domain.OngoingTransaction.Status, for transactionId: TransactionId) {
        switch transactionStatus {
        case .correct:
            onPaymentCompleted.on(.next(transactionId))
        case .error:
            onPaymentFailed.on(.next(transactionId))
        default:
            break
        }
    }
}
