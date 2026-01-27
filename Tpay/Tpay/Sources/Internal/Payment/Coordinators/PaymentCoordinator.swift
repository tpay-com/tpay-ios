//
//  Copyright © 2022 Tpay. All rights reserved.
//

final class PaymentCoordinator {
    
    // MARK: - Events
    
    var closeModule: Observable<Void> { sheetViewController.closeButtonTapped }
    let paymentCreated = Observable<TransactionId>()
    let paymentCompleted = Observable<TransactionId>()
    let paymentFailed = Observable<TransactionId>()
    let errorOccurred = Observable<ModuleError>()
    
    // MARK: - Properties
    
    let sheetViewController: SheetViewController
    
    private let transaction: Transaction
    private var temporaryPayer: Domain.Payer?
    private let presenter: ViewControllerPresenter
    private let resolver = ModuleContainer.instance.resolver

    private let synchronizationService: SynchronizationService
    
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
        synchronizationService = resolver.resolve()
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    // MARK: - API
    
    func start() {
        setupActions()
        
        synchronizationService.fetchPaymentData { [weak self] result in
            Logger.info(result)
            self?.prefetchResources()
            if case .failure(let error) = result {
                self?.handle(error: error)
            }
        }
        
        startPaymentFlow()
    }
    
    func stop() {
        currentFlow = nil
    }
    
    // MARK: - Private
    
    private func setupActions() {
        sheetViewController.languageSelected
            .skip(first: 1)
            .subscribe(onNext: { [weak self] language in self?.changeLanguage(language) })
            .add(to: disposer)
        
        sheetViewController.changePayerDetails
            .subscribe(onNext: { [weak self] in self?.startPaymentFlow() })
            .add(to: disposer)
        
        sheetViewController.onLanguageSwitchTap
            .subscribe(queue: .main, onNext: { [weak self] in
                guard let setupPaymentFlow = self?.currentFlow as? SetupPaymentFlow else {
                    return
                }
                setupPaymentFlow.endEditing()
            })
            .add(to: disposer)
    }
    
    private func prefetchResources() {
        synchronizationService.prefetchRemoteResources { result in
            Logger.info("Remote resources prefetch result: \(result)")
        }
    }
    
    private func changeLanguage(_ to: Language) {
        ModuleContainer.instance.currentLanguage = to
        startPaymentFlow()
    }
    
    private func startPaymentFlow() {
        let setupPaymentFlow = SetupPaymentFlow(for: transaction, with: presenter, using: resolver, payerOverride: temporaryPayer)

        setupPaymentFlow.showPayerDetails
            .subscribe(onNext: { [weak self] payerDetails in self?.sheetViewController.set(payerDetails: payerDetails) })
            .add(to: disposer)
        
        setupPaymentFlow.transactionCreated
            .subscribe(queue: .main, onNext: { [weak self] transaction in
                self?.paymentCreated.on(.next(transaction.transactionId))
                self?.startProcessingFlow(for: transaction)
            })
            .add(to: disposer)
        
        setupPaymentFlow.errorOcurred
            .subscribe(queue: .main, onNext: { [weak self] error in self?.handle(error: error) })
            .add(to: disposer)
        
        setupPaymentFlow.onPayerUpdate
            .subscribe(queue: .main, onNext: { [weak self] payer in self?.temporaryPayer = payer })
            .add(to: disposer)
        currentFlow = setupPaymentFlow
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
            .subscribe(onNext: { [weak self] in self?.startPaymentFlow() }) // TODO: implement a possibility to retry created transaction instead of creating a new one
            .add(to: disposer)
        
        currentFlow = processingPaymentFlow
    }
        
    private func handle(error: Error) {
        Logger.error(error)
        let snack = Snack(message: error.localizedDescription, kind: .error)
        presenter.present(snack)
    }
}
