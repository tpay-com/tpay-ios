//
//  Copyright © 2023 Tpay. All rights reserved.
//

final class CardTokenPaymentFlow: ModuleFlow {
    
    let paymentCompleted = Observable<TransactionId>()
    let paymentFailed = Observable<TransactionId>()
    let errorOcurred = Observable<ModuleError>()
    
    // MARK: - Properties
    
    private let transaction: Transaction
    private let presenter: ViewControllerPresenter
    private let resolver: ServiceResolver
    
    private let screenManager: ScreenManager
    
    private let mapper: APIToDomainModelsMapper = DefaultAPIToDomainModelsMapper()
    private let transactionBuilder: Domain.Transaction.Builder
    
    private var disposer = Disposer()
    
    // MARK: - Initializers
    
    init(for transaction: Transaction, with presenter: ViewControllerPresenter, using resolver: ServiceResolver) {
        self.transaction = transaction
        self.presenter = presenter
        self.resolver = resolver
        screenManager = ScreenManager(presenter: presenter)
        transactionBuilder = Domain.Transaction.Builder(paymentInfo: mapper.makePaymentInfo(from: transaction))
    }
    
    deinit {
        Logger.debug("deinit from: \(self)")
    }
    
    // MARK: - API
    
    func start() {
        guard let payer = transaction.payerContext?.payer else {
            assertionFailure("Cannot find payer object")
            return
        }
        transactionBuilder.set(payer: mapper.makePayer(from: payer))
        
        showCardTokenPaymentScreen()
    }
    
    func stop() { }
    
    // MARK: - Private
    
    private func showCardTokenPaymentScreen() {
        guard let cardToken = transaction.payerContext?.tokenizedCards.map({ mapper.makeCardToken(from: $0) }).first else {
            errorOcurred.on(.next(PayerContextConfigurationError.tokenizedCardEmpty))
            return
        }
        
        guard let transaction = transactionBuilder.build() else {
            assertionFailure("Cannot construct transaction object")
            return
        }
        
        let screen = CardTokenPaymentScreen(for: transaction, with: cardToken, using: resolver)
        
        screen.router.onPaymentCompleted
            .subscribe(queue: .main, onNext: { [weak self] transactionId in self?.showPaymentSuccessScreen(for: transactionId) })
            .add(to: disposer)
        
        screen.router.onPaymentFailed
            .subscribe(queue: .main, onNext: { [weak self] transactionId in self?.showPaymentErrorScreen(for: transactionId) })
            .add(to: disposer)
        
        screen.router.onError
            .subscribe(queue: .main, onNext: { [weak self] error in self?.showPaymentErrorScreen(for: error) })
            .add(to: disposer)
        
        screenManager.show(screen)
    }
    
    private func showPaymentSuccessScreen(for transactionId: TransactionId) {
        let successContent = SuccessContent(title: Strings.paymentSuccessTitle,
                                            buttonTitle: Strings.paymentSuccessButtonTitle,
                                            description: nil)
        let screen = SuccessScreen(content: successContent)
        
        screen.router.onProceed
            .subscribe(onNext: { [weak self] in self?.paymentCompleted.on(.next(transactionId)) })
            .add(to: disposer)
        
        screenManager.show(screen)
    }
    
    private func showPaymentErrorScreen(for transactionId: TransactionId) {
        let failureContent = FailureContent(title: Strings.paymentFailureTitle,
                                            primaryButtonTitle: Strings.paymentFailureButtonTitle,
                                            description: nil,
                                            linkButtonTitle: nil)
        let screen = FailureScreen(content: failureContent)
        
        screen.router.onCancel
            .subscribe(onNext: { [weak self] in self?.paymentFailed.on(.next(transactionId)) })
            .add(to: disposer)
        
        screenManager.show(screen)
    }
    
    private func showPaymentErrorScreen(for error: PaymentError) {
        let failureContent = FailureContent(title: Strings.paymentFailureTitle,
                                            primaryButtonTitle: Strings.paymentFailureButtonTitle,
                                            description: nil,
                                            linkButtonTitle: nil)
        let screen = FailureScreen(content: failureContent)
        
        screen.router.onPrimaryAction
            .subscribe(onNext: { [weak self] in self?.errorOcurred.on(.next(error)) })
            .add(to: disposer)
        
        screenManager.show(screen)
    }
}
