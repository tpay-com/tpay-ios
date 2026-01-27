//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class CardTokenPaymentCoordinator {
    
    // MARK: - Events
    
    var closeModule: Observable<Void> { sheetViewController.closeButtonTapped }
    let paymentCompleted = Observable<TransactionId>()
    let paymentFailed = Observable<TransactionId>()
    let errorOccured = Observable<ModuleError>()
    
    // MARK: - Properties
    
    let sheetViewController: SheetViewController
    
    private let transaction: Transaction
    private let presenter: ViewControllerPresenter
    private let resolver = ModuleContainer.instance.resolver
    
    private var currentFlow: ModuleFlow? {
        didSet {
            oldValue?.stop()
            currentFlow?.start()
        }
    }
    
    private var disposer = Disposer()
    
    // MARK: - Initializers
    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        sheetViewController = SheetViewController()
        presenter = ContentViewControllerPresenter(sheetViewController: sheetViewController)
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    func start() {
        startCardTokenPaymentFlow()
    }
    
    func stop() {
        currentFlow = nil
    }
    
    // MARK: - Private

    private func startCardTokenPaymentFlow() {
        let cardTokenPaymentFlow = CardTokenPaymentFlow(for: transaction, with: presenter, using: resolver)
        
        cardTokenPaymentFlow.paymentCompleted
            .forward(to: paymentCompleted)
        
        cardTokenPaymentFlow.paymentFailed
            .forward(to: paymentFailed)
        
        cardTokenPaymentFlow.errorOcurred
            .forward(to: errorOccured)
        
        cardTokenPaymentFlow.processTransactionWithUrl
            .subscribe(onNext: { [weak self] ongoingTransaction in self?.startProcessingFlow(for: ongoingTransaction) })
            .add(to: disposer)
        
        currentFlow = cardTokenPaymentFlow
    }
    
    private func startProcessingFlow(for transaction: Domain.OngoingTransaction) {
        let processingPaymentFlow = ProcessingPaymentFlow(ongoingTransaction: transaction, presenter: presenter, resolver: resolver)
        
        processingPaymentFlow.paymentCompleted
            .map { transaction.transactionId }
            .forward(to: paymentCompleted)
        
        processingPaymentFlow.paymentCancelled
            .map { transaction.transactionId }
            .forward(to: paymentFailed)
        
        processingPaymentFlow.retry
            .subscribe(onNext: { [weak self] in self?.startCardTokenPaymentFlow() }) // TODO: implement a possibility to retry created transaction instead of creating a new one
            .add(to: disposer)
        
        currentFlow = processingPaymentFlow
    }
}
